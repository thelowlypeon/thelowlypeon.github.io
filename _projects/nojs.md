---
layout: post
title:  "NoJS"
date:   2015-11-26 17:26:32 -0500
categories: ios javascript
image: projects/nojs.png
caption: Easily view any page without JS on your iOS device with NoJS. Easily debug your site, improve load times, or avoid pesky interruptions.
more: https://itunes.apple.com/us/app/no-js/id1062685513?mt=8
appstore: https://itunes.apple.com/us/app/no-js/id1062685513?mt=8
redirect_from:
  - /post/134015575196/introducing-nojs
  - /post/135125946151/nojs-on-the-app-store
  - /134015575196/introducing-nojs
---

<dialog id="annoying-popup">
  <article>
    <header>
      <button aria-label="Close" rel="prev" data-close></button>
      <h4>You're allowing this to happen!</h4>
    </header>
    <div id="ip-info" hidden>
      <h5>How's the weather in <strong id="address"></strong>, by the way?</h5>
      <p>Oh, and in case you were curious. I know your IP is <code id="ip"></code>.</p>
    </div>
    <p>By enabling javascript, this stuff is bound to happen.</p>
    <p>But never fear!</p>
    <p>Download <a href="{{ page.appstore }}">NoJS</a> and refresh the page temporarily without javascript!</p>
    <div style="margin-top:20px;">
      <a href="{{ page.appstore }}"><img src="/assets/images/app-store.png" width="180px;"></a>
    </div>
    <footer>
      <a href="#" class="dismiss" data-close>No thanks,<br />I love being interrupted</a>
      <span class="sorry" hidden>Sorry. Javascript can do this too :(</span>
    </footer>
  </article>
</dialog>

<noscript>
  <header class="post-header">
    <div class="project-feature bottom-buffer" id="feature-{{ page.slug }}">
      <div class="narrow">
        <h3 style="color:#a7b583">Looks like your Javascript is disabled! Hooray!</h3>
        <p>Did you see how much faster the page loaded?</p>
        <hr />
      </div>
    </div>
  </header>
</noscript>

Ever realize how pesky javascript can be?

It tracks you,
it can run malicious code in your browser,
it blocks content with annoying popups,
and it breaks lots of websites.

#### With NoJS, available for iOS, with only two taps you can:

* Prevent client-side trackers
* Prevent execution of <a href="http://www.welivesecurity.com/2016/12/06/readers-popular-websites-targeted-stealthy-stegano-exploit-kit-hiding-pixels-malicious-ads/">malicious client-side code</a>
* Prevent popups, including many paywalls
* Prevent websites from breaking, including annoying scrolljacking business that breaks basic browser functionality

#### Privacy

NoJS doesn't track anything. At all. URLs you share with NoJS remain entirely on device, as does any browsing you do in the app.

<script type="text/javascript">

setTimeout(function() {
  var popup = document.getElementById("annoying-popup");

  fetch("https://ipinfo.io/json")
    .then(function(response) { return response.json(); })
    .then(function(info) {
      document.getElementById("ip").textContent = info.ip;
      document.getElementById("address").textContent = info.city + ", " + info.region;
      document.getElementById("ip-info").hidden = false;
    })
    .catch(function() {});

  popup.querySelectorAll("[data-close]").forEach(function(el) {
    el.addEventListener("click", function(e) { e.preventDefault(); popup.close(); });
  });
  popup.addEventListener("click", function(e) {
    if (e.target === popup) popup.close();
  });
  popup.querySelector(".dismiss").addEventListener("mouseenter", function() {
    this.hidden = true;
    popup.querySelector(".sorry").hidden = false;
  });

  popup.showModal();
}, 2000);
</script>
