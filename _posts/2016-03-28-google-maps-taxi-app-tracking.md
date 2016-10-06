---
layout: post
title:  "iOS Google Maps Checking for Taxi Apps"
date:   2016-03-28 08:47:20 -0500
categories: jekyll
tags: ios, privacy, google
author: peter
---

I recently was working on adding an "action extension" to [Station to Station](https://stationtostationapp.com) so you can quickly view stations nearby a location you may be viewing in another app.

(For example, if you're viewing a contact's vcard, and it has an address, you can tap the "share" icon, and an extension appears saying "View nearby stations".
This is super helpful for when you're taken to a map from another app, or a link, and want to take bikeshare to get there.)

I was running through all the apps I had on my phone where I thought this would be useful: Apple Maps, Contacts, Yelp, Google Maps, etc.

When I launched the extension scheme and told Xcode to run Google Maps, I saw this immediately on launch:

![](/assets/images/posts/google-maps-taxi-app-tracking-logs.png)

`canOpenURL` is a method your app can call to see if the device can handle specific URLs. For example, if you wanted to compose a tweet from your app,
you can check if the device responds to the custom URL scheme `twitter://`, and if not, go to the website in Safari. It's a super useful tool in many cases.

In this case, Google Maps is checking to see if it can open URLs for:

* `mytaxi://`
* `easytaxi://`
* `gett://`
* `hailoapp://`
* `olacabs://`
* `taxis99://`

I can't say for sure what Google is doing with this, if anything. But I _can_ say I'm not sure I trust their intentions.
