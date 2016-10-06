---
layout: post
title: "Gem Dependency Woes: Faraday and Tumblr Client"
date: 2014-05-03 14:28:18 -0500
categories: gem dependency tumblr
redirect_from: /84642056436/gem-dependency-woes-faraday-and-tumblr-client
---

Well there goes the better part of my Saturday.</p>

I’ve been working on a project lately that heavily leans on <a href="http://petercompernolle.com/projects/mumblr">Mumblr</a>, a gem I wrote that will fetch your content from Tumblr, cache it locally in MongoDB, and keep things up to date. (It’s pretty awesome — in fact, all the content on <a href="http://petercompernolle.com">petercompernolle.com</a> is managed via Tumblr using tags and a handful of private posts.)

A few days ago, I started getting 500 errors, and nearly all of my Mumblr tests were failing with the same error:

```
NoMethodError: undefined method `client=' for #<Faraday::ConnectionOptions:0x00000101c295c8>
~/.rvm/gems/ruby-2.0.0-p451/gems/faraday-0.9.0/lib/faraday/options.rb:31:in `block in update'
~/.rvm/gems/ruby-2.0.0-p451/gems/faraday-0.9.0/lib/faraday/options.rb:20:in `each'
~/.rvm/gems/ruby-2.0.0-p451/gems/faraday-0.9.0/lib/faraday/options.rb:20:in `update'
~/.rvm/gems/ruby-2.0.0-p451/gems/faraday-0.9.0/lib/faraday/options.rb:52:in `merge'
~/.rvm/gems/ruby-2.0.0-p451/gems/faraday-0.9.0/lib/faraday.rb:69:in `new'
```

I immediately checked the <a href="https://github.com/tumblr/tumblr_client/">tumblr_client</a> github repo, as well as the <a href="https://github.com/lostisland/faraday">faraday</a> repo, which appeared to be causing the error. No updates for a few months. Hmm.

I dug into the gem itself, and found that Faraday was making a <code>send</code> call when <a href="https://github.com/lostisland/faraday/blob/3dc615a72eae5cec55d2c73dfdd8efea00f2c283/lib/faraday/options.rb#L31">setting options</a> without checking that <code>self.respond_to?("#{key}=")</code>. To make sure I wasn’t being an idiot, I made a few changes, and kept getting farther, and that certainly was the issue: like the message said, <code>Faraday::ConnectionOptions</code> doesn’t respond to <code>client=</code>. Okay, great. So now what?

I updated Ruby, assuming my outdatedness came to bite me in the ass. But wait — my <em>other sites</em> are having the issue too, and one of them uses a newer version of Ruby (2.1.0). So back to digging.

The answer was frustratingly obvious. <code>tumblr_client</code> recently <a href="https://github.com/tumblr/tumblr_client/commit/8b7a0ab493cc9cf0540cc3e9cf45ee1c7504cb73#diff-6057c9b3ad0886d8321a320167c4b927R6">changed their dependency</a> on Faraday, and so I can only assume I ran a <code>bundle update</code> without realizing the issue.

So, I:

Uninstalled faraday 0.9.0:

```
gem uninstall faraday --version 0.9.0
```

Added it 0.8.0 to my Gemfile:

```
gem 'faraday', '0.8.0'
gem 'mumblr', github: 'thelowlypeon/mumblr'
```

And manually installed it to make sure:

```
gem install faraday --version 0.8.0
```

And now we’re all good. Sigh. I wish I had my hours back.
