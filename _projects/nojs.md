---
layout: project
title:  "no.js"
date:   2015-11-26 17:26:32 -0500
categories: ios javascript
image: nojs.png
caption: Easily view any page without JS on your iOS device with no.js. Easily debug your site, improve load times, or avoid pesky interruptions.
more: https://itunes.apple.com/us/app/no-js/id1062685513?mt=8
redirect_from:
  - /post/134015575196/introducing-nojs
  - /post/135125946151/nojs-on-the-app-store
---

Easily view any page without JS on your iOS device with no.js. Easily debug your site, improve load times, or avoid pesky interruptions.

<a href="https://itunes.apple.com/us/app/no-js/id1062685513?mt=8"><img src="/assets/images/app-store.png" width="180px;"></a>

***

A week or so ago, I went to a site that wouldn't allow scrolling when Javascript was enabled. It turned out to be a pesky Safari CSS bug, but it wasn't a problem when Javascript was disabled, because Modernizr was assigning the CSS class.

Meanwhile, every time someone sends me a link to the Chicago Tribune, I get stuck behind the paywall, and need to go into Settings / Safari / Advanced, and toggle Javascript. Then go back to the page, reload, and then go back into settings.

On top of all that, Javascript sometimes just drives me crazy.

So I decided: why not make a simple action extension that allows a quick, painless, temporary disabling of Javascript. iOS 9 introduced SFSafariViewController, a simple way to present an in-app browser with all the benefits of native Safari, as well as content blockers - perfect for my new idea.

A few hours later, I concluded it was impossible to use SFSafariViewController without conditionally setting content blockers and then unsetting them, which was too complicated. So instead, I used a good ol' fashioned WKWebView, with some lightweight UI elements.

In the end, viola! no.js is now finished, working wonderfully, and pending app store review. Hooray!
