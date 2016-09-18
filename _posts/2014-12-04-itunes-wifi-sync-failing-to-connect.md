---
layout: post
title: "iTunes Wifi Sync Failing to Connect"
date: 2014-12-04 22:15:37 -0500
categories: itunes iphone wifi technology
redirect_from: /post/104384206711/itunes-wifi-sync-failing-to-connect
---

For the last several months, my iPhone has been failing to sync over wifi with iTunes. My iPad has had no problem.

This has been happening for me periodically for the last several years, but has been constant since iTunes 11 (I'm now on iTunes 12) and iOS 7 (now on iOS 8).

Turns out the solution is simple, even if bogus:

**I turned off automatic time updates on my iPhone and restarted it.**

Apple has a few knowledgebase articles that say iTunes wifi sync requires port 123 to be open, which happens to be the port that the automatic updates use.

I'm not thrilled with this solution, but the problem has been driving me far crazier than resetting my clock every now and then.
