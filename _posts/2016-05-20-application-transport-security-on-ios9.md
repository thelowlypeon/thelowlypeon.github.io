---
layout: post
title: "Local Development and Application Transport Security on iOS 9+"
date: 2016-05-20 11:15:00 -0500
categories: ios security development
reposted_from:
  site: the One Design Company blog
  url: https://onedesigncompany.com/news/application-transport-security-on-ios-9
  date: 2016-05-20
---

As of iOS 9, Apple requires network requests to be secure by default. This means that apps cannot make requests over HTTP without explicitly whitelisting them.

This is great -- at ODC, we’re strong believers in application security, and with services like Heroku enabling SSL certificates by default, or [LetsEncrypt](https://letsencrypt.org/) making it insanely easy to add a certificate to your own server, there’s no reason not to.

In development, though, this can be a bit of a pain. We typically do our development in three environments -- local, staging, and production -- and although we have certificates for the latter two, we often run our APIs locally without a self-signed certificate to avoid unnecessary setup and to make it easier to inspect traffic. This means that, by default, iOS in the simulator will shoot down any requests made to our localhost API.

The solution for this is easy, requiring only two quick steps: 

* Tell Xcode to build for use with a local API when in development (aka `DEBUG`), and to use the production, secure API for archives and distribution (aka `RELEASE`) builds
* Allow iOS to contact your local API over HTTP.

## Step 1: Defining your API base URL by Environment

By default, Xcode build schemes will use “debug” for builds, and “release” for archives. There are a number of differences between the two, but for now, there’s just one: in our project’s build settings, we can send a compiler flag based on the scheme.

In the project navigator, select your target, and then the “Build Settings” tab. In the “Swift Compiler - Custom Flags” section, expand “Other Swift Flags”, and in the debug option, add:

```bash
-D DEBUG
```

This will send the DEBUG flag to the Swift compiler whenever we build using a “debug” scheme.

Meanwhile, in our code, we can define our API base using a preprocessor macro. Normally, we would define our API base URL using a constant, eg:

```swift
let API_BASE_URL = "https://api.myproject.com"
```

We _could_ change this URL to be `"http://localhost:9292"` on the fly, but that would risk accidentally committing or building with it, and would be a change to make every time you need to change environments. Instead, let’s use that little DEBUG flag:

```swift
#if DEBUG
    let API_BASE_URL = "https://api.myproject.com"
#else
    let API_BASE_URL = "http://localhost:9292"
#endif
```

The `#if`... `#else`... `#endif` is a _preprocessor macro_, which means it is evaluated _before_ the code is compiled. In other words, if DEBUG evaluates to true, as it does in our “debug” scheme, the else block doesn’t even exist in the compiled build. 

So, our app can now use a different API based on the build environment! Yay! Unfortunately, iOS will deny any requests to `http://localhost:9292` until we whitelist the domain.

## Step 2: Whitelisting localhost for Unsecure Requests

At this point, our app knows to make requests to localhost when in development, but the simulator fails on each request, showing an error like this:

```
App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.
```

As the error suggests, this is because our request to http://localhost, which is no longer acceptable, unless whitelisted. Whitelisting it, it turns out, is rather easy: we just need to update Info.plist with an “exception domain”.

In your project’s Info.plist, add the following:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>localhost</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

Alternatively, if you prefer Xcode’s plist editor, define a new key called `NSAppTransportSecurity` of type dictionary, which has a child `NSExceptionDomains`, also a dictionary, which has a dictionary child called `NSExceptionDomains` (this will work with any domain, of course, but you should be using HTTPS on publicly accessible domains), which has a boolean child `NSExceptionAllowsInsecureHTTPLoads` set to YES:

![](/assets/images/posts/application-transport-security.png)

Note that your exception domains should not include a port number or protocol (HTTP vs HTTPS). 

And that’s it! You can now develop using a local API, but build and test using your remote, secure API.
