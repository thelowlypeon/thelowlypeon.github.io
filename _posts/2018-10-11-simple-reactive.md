---
layout: post
title:  "Simple Reactive Programming"
date:   2018-10-11 15:04:00 -0500
categories: swift ios mobile programming simple-reactive
editors_note: A colleague insisted Reactive Programming for iOS in Swift required depending on RxSwift or ReactiveCocoa/ReactiveSwift. I disagree. This is my evidence.
---

Two years ago I wrote an iOS app that leaned heavily on [ReactiveCocoa][ReactiveCocoa].
Going from MVC to MVVM with a framework like ReactiveCocoa was to me a life-changing
experience, so much that I was willing to relax my strong feelings _against_ third party
dependencies to be able to do it.

The app has several hundred daily active users across a handful of countries, but juggling
a toddler, full time job, and a side project meant the time I could afford to maintain the app
generally went to improving the reliability of the backend serving it real time data.

My daughter is now almost two, and can entertain herself, so recently I've been working on
bringing my side projects back into the foreground. I sat down a few weeks ago to add a watch
complication for this app, and lo and behold, it wouldn't even build. The version of ReactiveCocoa
the app is locked to was, at the time, their first release to support Swift 3 syntax, which
uses now-deprecated iOS APIs, making it impossible to build. But updating requires a _significant_
rebuild of my app, given how dependent it is on the framework.

I complained to a friend and long time iOS developer, who said he'd never built anything reactive
in iOS that _didn't_ depend on either RxSwift or ReactiveCocoa/ReactiveSwift.
I took that as a challenge, and quickly drafted a few Swift Playgrounds using different patterns
that would allow for easy reactive programming, with zero dependencies, and simple enough that
they were unlikely to break with subsequent iOS or Swift updates.

Stay tuned for a few different patterns I tried, what I like about them, what I don't,
and my ultimate conclusion about whether I'll stick with my own code, or if I'm just
reinventing the wheel.

Part 1: [Key-Value Observing](/2018/simple-reactive-kvo)
Part 2: [Notifier](/2018/simple-reactive-notifier)

[ReactiveCocoa]: https://github.com/ReactiveCocoa/ReactiveCocoa
