---
layout: post
title: "Maybe It's All Too Connected"
date: 2014-12-06 11:35:00 -0500
categories: dependencies
redirect_from: /post/104502480226/maybe-its-all-too-connected
---

<em>A few days ago, upon realizing my iPhone hadn’t synced with my always-on-and-available Mac Mini for several months, I decided to invest some time into trying to fix it. Eventually, I found a solution, and wanted to let future googlers know in case they had the same problem. As I opened up Tumblr to write my post, I realized that my server had been throwing 500 errors when trying to sync with Tumblr.</em></p>

<hr>My blog, then written in PHP sitting on MySQL, started becoming a headache to maintain a few years ago. All too often, I’d forget how my homegrown markdown worked, or I’d forget to close a tag, or I’d want an inline image (which my site didn’t support), and I’d have to open up an ssh session and update the post directly in MySQL. Gross, right? So I decided to move it over to Tumblr; this way, a team of smarter people would make sure my blogging platform was working, I could post easily from my iPhone, and I’d maybe get more exposure from the Tumblr community. The only costs: I’d need to learn and write a Tumblr theme to match my site, and write a bunch of 301 redirects from my old URLs to the new ones (because Tumblr URLs, though customizable via a slug, have a pesky number that my site previously did not), and copy over all my content.

When I first started programming, mostly because of a hugely influential friend and mentor, <a href="http://bentomas.com">Benjamin Thomas</a>, I was a purist. Anything I wrote, <em>I wrote</em>. The few times I used a third party library, I either got frustrated trying to integrate it (this was a long time ago, remember, and there were no package managers outside of MacPorts and the like), or found myself spending more time modifying it for my project than I would have spent simply <em>writing it myself</em>. Further, if something broke, I believed strongly, I’d have a better understanding of my own code than someone else’s. I remember using Rails 0.x years ago, and nearly throwing my computer out the window when the upgrade to 1.0 broke everything.

Years later, I was the technical cofounder of a small startup, building a too-large product on top of CodeIgniter, and my mind was changing. We used Ion Auth, instead of writing our own likely-vulnerable authentication, which took all of five minutes to implement. We used ImageMagick for manipulating profile photos, etc. Either the world had come a long way since I first started building websites, or I had — using these third party libraries meant I could quickly move on to the next task, and spend less time worrying about whether I’ve covered all my bases. Sure, it was still frustrating at time <em>bending</em> these tools to fit my needs, and more frustrating when a misunderstanding on my part cost us time or introduced bugs.

It was in that mindset I decided to move my blog from my homegrown solution — that’d worked well for almost a decade! — to a platform that is being developed much faster, and much more reliably. Aside from the URLs changing, and my assumption that it hurt my SEO, I was pleased with the decision to move. It meant I no longer needed to worry about much: make sure my website is up, my links are still valid, and Tumblr doesn’t go down.

And so, after years of building LAMP based projects, I decided it was time to do something in Rails. Rails had (somehow) become the new standard of bloated web frameworks, and although much of that was because of career-changers going to dev bootcamp and coming out “experts”, I was curious to give it another shot since my failure of an experience with Rails 1.0. Sure enough, it had come a <em>long way</em>.

What impressed me the most was the huge community building gems for Rails. (Of course, many say it works with anything Ruby, but that’s just as false as most Stack Overflow posts describing Ruby methods like <code>.each</code> or <code>to_s</code> as “Rails methods”.) Need to add authentication to your web app? <code>gem 'devise'</code>. Need to style your <em>entire site</em> without writing any CSS? <code>gem 'less-bootstrap-rails'</code>. Need a more robust implementation of markdown than your homegrown version would ever be? <code>gem 'redcarpet'</code>. It was that simple. You could practically build a complete site by writing a single <code>.erb</code> file.

> Starting a basic website in 2014:
>
> 1. Install Node
> 2. Install Bower
> 3. Pick CSS framework
> 4. Pick responsive approach
> …
>
> 47. Write some HTML

<em>— I Am Devloper (@iamdevloper) <a href="https://twitter.com/iamdevloper/status/517616294909464576">October 2, 2014</a></em>

<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Then one day, while pushing out a minor patch to <a href="http://ootheloop.com">Out of the Loop</a>, my Rails experiment, everything broke. Turns out one of the gems I was using got a major update despite being the same .x version, and I accidentally ran <code>bundle update</code>. I realized then that my site was hardly even <em>my site</em>: it was a tightly knotted combination of work of thousands of other people, independently building their pieces of the disgusting puzzle I was putting together.

Seriously: look at a Rails app, and try to identify code that was actually written for the project. Aside from the <code>.erb</code> files, and perhaps some controller or model functions (which were all, of course, originally generated using <code>rails g</code>), everything else is from something else. (This is especially apparent when given code samples for Software Engineering candidates that are Rails apps.)

So when it came time to rebuild <a href="http://petercompernolle.com">petercompernolle.com</a> with Tumblr integration, I decided to build my own gem. One that I’d manage, but would also open source, and use for other micro-sites for which I didn’t want to deal with building a CMS of any kind.

I built <a href="http://petercompernolle.com/projects/mumblr">Mumblr</a> (because Mongo+Tumblr=Awesome), and threw it into my Gemfile. It was brilliant — all of the content on this site is now coming from Tumblr. The landing page, for example, is receiving content from the most recent (hidden) post on my Tumblr tagged with “mumblr_welcome_message”:

```
@welcome_message = Mumblr::TextPost.tagged('mumblr_welcome_message').first
```

Since then, I’ve written four sites using Mumblr (all but this with Sinatra), and it’s working pretty much exactly as I’d hoped — it’s nearly zero maintenance, I can manage them from my iPhone using the Tumblr app, and it’s blazing fast due to be stored (“cached”) in Mongo on the web server, avoiding the need for constant communication with Tumblr.

And it was a problem with Mumblr that was giving me those 500 errors mentioned above. It was a stupid simple problem: Tumblr had added a field to their API that I didn’t include in my models. This is the second time its happened, so instead of simply adding the field, I decided to <a href="https://github.com/thelowlypeon/mumblr/commit/da5c90452793586f7259ea7c98d18921bfcfa033">ignore fields that Mumblr didn’t recognize</a>. (Yes, this should’ve been happening from the start. Funny how “schema-less databases” still require a schema?)

I built a pretty big test suite for Mumblr, and before committing the change, I ran the tests. Uh oh. Lots of big errors, unrelated to my change. I wrote the tests using Test::Unit, <a href="http://www.ruby-doc.org/stdlib-2.1.5/libdoc/test/unit/rdoc/Test/Unit.html">included as part of Ruby</a>. The errors told me I needed to change my tests to use MiniTest, because TestUnit was being deprecated. Sweet. I added MiniTest to my Gemfile, and then started getting errors saying “uninitialized constant Minitest::TestCase” where I was using <code>Test::Unit::TestCase</code>. So I started rewriting my tests using Minitest. Then I discovered that my errors were because I was using Ruby 2.0 instead of 1.9.3. So I changed to 1.9.3 with rvm, which of course didn’t work because I was on a different machine, which only had 2.0. So I used rvm to install 1.9.3, which failed because I didn’t have gcc46. So, using homebrew, I installed gcc46. But do that, I needed to update and repair homebrew, which had gotten somehow corrupt when I upgraded to Yosemite. Turns out something had gone wrong with my bash ~/.profile during the upgrade too, because the file I hadn’t changed in months suddenly started giving me issues.

I fixed my <strong>bash</strong> profile, corrupted by <strong>Yosemite</strong>, which allowed me to repair <strong>homebrew</strong>, which allowed me to install <strong>gcc46</strong> (which took forever), which allowed me to use <strong>rvm</strong> to install a deprecated version of <strong>Ruby</strong>, which allowed me to run my tests with <strong>TestUnit</strong>, which allowed me to use <strong>git</strong> to commit my change to <strong>Mumblr</strong>, which allowed me to update the Mumblr version in my <strong>Gemfile</strong> for my <strong>Rails</strong> site, which allowed me to once again sync my blog with <strong>Tumblr</strong>, which allowed me to finally write about fixing my <a href="http://petercompernolle.com/104384206711/itunes-wifi-sync-failing-to-connect">wifi syncing</a> for my <strong>iPhone</strong>.

<hr>So, maybe it’s time I stop trying to put together all these crazy puzzle pieces and simplify things.
