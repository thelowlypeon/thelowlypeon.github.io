---
layout: post
title:  "Apps Sharing Data with Facebook"
date:   2018-12-28 13:49:31 -0500
categories: privacy facebook data sharing evil
---

_UPDATE 2018-01-02: privacy.com responded with the following: "I've shared this with the team and will ensure we investigate this thoroughly and remove it in the next iOS deploy."_

---

As I noted in my recent post about [Mint sending data to Facebook](/2018/intuit-mint-facebook),
I discovered several POST requests going to `graph.facebook.com` containing
data about my device, among other things, despite having no Facebook account,
using no Facebook services personally, and blocking all traffic to `*.facebook.com`
from my home network. I learned shortly after that post that _many_ apps on my device
are making such requests, and decided to investigate a bit further.

Disclaimer: I was not authenticated in all apps when running these tests,
so it's very possible there'd be more requests once I authenticate.
This is the result of very manual, non-lab-like research. I'm sure I missed some things.

### Facebook Software Development Kit

The iOS Facebook SDK, with user-agent `FBiOSSDK`, is made available to any developer who
wishes to use Facebook's services in their app. Such services include push notifications,
the horrifying "login using facebook" oauth function, App Events, Facebook Analytics, and Graph API.

#### Dependencies

Possibly unbeknownst to app developers using this SDK, since developers rarely
read terms when using open source libraries, and because we live in an era where
"don't re-invent the wheel" is synonymous with "I don't want to do that myself,"
Facebook makes clear in their README that:

> By enabling Facebook integrations, including through this SDK,
> you can share information with Facebook,
> including information about people’s use of your app.
> ...
> These integrations also enable us and our partners to serve ads on and off Facebook.

My initial theory was that Intuit (via Mint's iOS app) was providing data to Facebook
so they could better serve ads. That may still be the case, but after seeing a great
number of other applications making similar requests, I now wonder if most are
doing this out of sheer neglect. After all, how else would developers of
[possibly millions of apps](https://www.theregister.co.uk/2016/03/23/npm_left_pad_chaos/)
know that their dependencies included a module just for left padding a string?

So if an app you use, for example, allows logging in via Facebook, or maybe has a button
to share the app with your Facebook friends, odds are good the app includes this
library, and is sending Facebook your data just by being bootstrapped
when the application launches.

### Data Sent

The data sent to Facebook seems to vary slightly by application and SDK version,
which makes sense given the SDK allows sending custom attributes with each request.

Much of this data is mostly harmful: iOS version, screen size, the bundle ID of the application.
But some of this could easily be used to identify patterns, or infer
details, about you personally.

#### All Requests

All requests that I identified sent the following (among other fields):

##### `advertising_id`

Back in the day, iOS provided a globally unique identifier to all apps to identify
which device the app was running on. Apple removed this in favor of a new identifier
they call the `advertising_id`. This value differs between apps, so it is of
limited use for identifying you as a human. However, if this isn't reset often,
it is enough for the application -- and now Facebook -- to track your behavior
across launches.

Apple recently found this was being exploited and not used for its intended purpose,
so they [started pulling apps](https://techcrunch.com/2014/02/03/apples-latest-crackdown-apps-pulling-the-advertising-identifier-but-not-showing-ads-are-being-rejected-from-app-store/)
from the App Store that used the advertising ID but never showed ads.
I'm not sure how some of the apps currently sending this to Facebook are getting
around this, because the ones I've noted do not serve ads.

I *strongly* recommend you disable your device's advertising ID by going to
Settings > Privacy > Advertising, and enable "Limit Ad Tracking". If you'd prefer
to leave ad tracking as is, I suggest you periodically reset your advertising identifier.

#### `POST /activities`

This was the most common request, as it was made multiple times when applications were in memory.

##### `anon_id`

Each `POST /activities` request contains a field called `anon_id`, or `old_anon_id`,
which is a UUID, [prefixed with XZ](https://github.com/facebook/facebook-objc-sdk/blob/9e604fed90f4ad47873e95bbb6655b402afc8af5/FBSDKCoreKit/FBSDKCoreKit/Internal/AppEvents/FBSDKAppEventsUtility.m#L143),
that appears to be unique to each application.

I did a little digging through the source and found that this value is persisted
locally in a file called `com-facebook-sdk-PersistedAnonymousID.json`. Because of iOS
sandboxing, this value cannot be shared outside of the app's sandbox.

##### `session_id`

I wanted to see if this file contained anything else, so I took a look at a recent
iPhone backup on my laptop (after decrypting). That file didn't include anything else,
but I did come across another file, `com-facebook-sdk-AppEventsTimeSpent.json`, which
included:

* `lastSuspendTime`
* `numInterruptions`
* `sessionID`
* `secondsSpentInCurrentSession`

The `sessionId` is included in these requests as well. This is likely used for
behavioral tracking.

##### Coarse Grain Location Data

I could not find an instance where Facebook was gathering my GPS coordinates,
even for apps I know to have access to my location (such as [Transit App](http://transitapp.com)),
but they all sent my timezone (both `CST` and `America/Chicago`),
and of course also sent my IP as part of the request. In other words,
by sending _any request at all_, Facebook knows roughly where my phone is any
time I launch or keep in memory one of these apps.

##### Carrier

Along with each request is my carrier. The fact that they're getting my IP
seems much worse to me, but the recent discovery that [most or all of the major US
carriers are attaching a unique identifier to all request headers](https://www.ghacks.net/2015/08/31/are-mobile-carrier-injected-tracking-headers-used-to-track-you/)
makes me incredibly
wary of what else a company as powerful as Facebook could do knowing my carrier.

##### Event

This end point is all about tracking events, afterall. So each includes an event
type, eg `MOBILE_APP_INSTALL`.

##### Misc

A key called `fb_mobile_launch_source` was provided with launch events. My guess
is this refers to whether an app was launched directly, via push notification,
or with a URL.

I was able to find out which of these apps use ReactNative too. Which is fun.

#### `POST /user_properties`

##### `user_unique_id`

This is stored in `NSUserDefaults`, and appears to be much like the `anon_id`.
Given my limited data set, I was unable to determine if this matched any other ID fields.

##### Custom Data

This contains a bunch of custom data based on the app developer's implementation.

For example, in a block called `custom_data`, one app sent:

* `is_old_user`
* `has_subsribed`
* `has_paid`

Another app sent only `{ "vpn_provider": "primary" }`, while a third sent `g_numberOfTrackedMetroAreas`.

#### `POST /`

This is a method for POSTing batches, and the request body contains an array of
the above request types. In my limited data set, I found very few apps to be batching
requests.

### Offending Applications

This is by no means an exhaustive list, but is a list of apps I personally use
regularly that I found to be making requests to Facebook. (Let me know if you find others!)

I found this list using [Charles for iOS](https://www.charlesproxy.com/documentation/ios/),
entering low power mode to minimize noise from background-running apps, launched a whole
lot of apps, then looked through the logs. (Note: you must enable SSL proxying for
this to work, because Facebook's SDK uses HTTPS.)

Bundle IDs are below for requests where available.

* At least one major credit card
* AirVisual (`com.airvisual.airvisual`)
* AmpliFi Client (`com.ubnt.amplifi`)
* Belingual (`com.beelinguapp.beelinguapp`)
* Belly
* ChowNow
* Curb (`com.ridecharge.TaxiMagic`)
* FXNOW
* Garmin Connect (`com.garmin.connect.mobile`)
* Happy Cow (`com.smoothlandon.happycow`)
* IMDb (`com.imdb.imdb`)
* KAYAK (`com.kayak.travel`)
* Kindle (`com.amazon.Lassen`)
* Launcher
* Mint (`com.mint.internal`)
* Outlook (`com.microsoft.office.outlook`)
* Pocket (`com.ideashower.ReadItLaterPro`)
* Privacy (`com.privacy.paybeta` -- see 2018-01-02 update)
* REI
* Seafood Watch
* Songkick
* Spotify
* Strava (`com.strava.stravaride`)
* Stryd (`com.athletearchitect.stryd`)
* Tor Browser (`com.pentaloop.torbrowser`) -- note: this made the most requests to Facebook
* Transit App (`com.samvermette.Transit` and `com.transitapp.transitx`)
* UPS My Choice (`com.ups.m.iphone`)
* Vivino Wine Scanner
* Walk Score
* White Noise (`com.tmsoft.WhiteNoiseLite`)
* Yelp (`com.yelp.yelpiphone`) -- this made a reasonable number of requests to Facebook, but makes an insane number of request to Yelp services when in the background
* Zoom

I'll point out that a company called `Privacy` is a strange one to be giving data
willingly to Facebook at their users' expense. This one was particularly heartbreaking.

### Conclusion

As a consumer, this is terrifying. I've already reached out to several of the services above,
or deleted others from my phone after closing my account.

As an app developer, this is extremely disappointing. Is it worth betraying your
users to add a feature you may not need? If the product is free, you're the product.

As a guy who likes being paid for his work, this should come as a warning.
This willingness among the tech community to share (or sell?) data is abhorrent,
and people need to start holding companies accountable.
I've already uninstalled many of these apps, and will discontinue using some services
entirely. (Note: I ripped MapBox out of an app when I discovered they were tracking
my users' location even when my app asked the framework to stop.)

And if you think Facebook is the only company lately hoarding data, you are absolutely
wrong. In fact, while looking through my request logs, I found far more requests to other services:
Crashlytics, `app-measurement.com`, `play.googleapis.com`, among others.

However, I'm now even more in love with AdBlocker, and found a new love with Charles Proxy.
Also, 1Password and Brave both don't send any such traffic anywhere; I'm very likely
to uninstall all apps I find tracking me and just stick with cookie-less web browsing
through 1Password's 1Browser or Brave.
