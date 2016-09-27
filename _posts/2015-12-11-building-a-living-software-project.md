---
layout: post
title: "Building a Living Software Project"
date: 2015-12-11 08:00:00 -0500
categories: eastman ios software agile
reposted_from:
  site: the One Design Company blog
  url: https://onedesigncompany.com/news/eastman-egg-app-building-a-living-software-project
  date: 2015-12-11
---

We recently wrapped up a [successful project here at ODC](https://onedesigncompany.com/work/the-eastman-egg-company), and in the time since, I’ve spent a fair amount of time reflecting, from an engineer’s perspective, what made it so much more successful than other projects of similar size, scope, or complexity. 

To begin with, the client believed in the software development process, and was fantastic to work with. They had narrowed down the desired functionality for the app: customers should be able to place an order at any time, and have it fire (sent to the kitchen) when they’re near the restaurant, so the food is fresh when they arrive. They were clear about a small handful of secondary goals, such as reliable offline use due to weak network signal in one of their locations, a loyalty program for their very loyal customer base, and a referral program, but they were very clear that these were secondary.

(Let’s not forget that they came to us assuming they’d get something reliable, and beautifully designed.)

So if the project was so straightforward, and the concept simple, what made it such a success from a technical perspective?

## Uncertainties

Right off the bat, there were a few things we were a few known project risks. After research and discussion, we narrowed our list of uncertainties down to about half a dozen. Many of them were easy to think up, such as working with a poorly documented third party’s API, but the more important part of this exercise was trying to identify the ones that didn’t jump out at us. 

For example, we’ve worked with several different location based technologies before, but never to solve a problem like this. Would monitoring for locations too early degrade battery life? Are iBeacons too granular, and thus not give the kitchen enough time to prepare everything? If so, are we willing to deal with the privacy implications of monitoring the actual location of a user’s device? Would we need to leverage multiple technologies to achieve our desired experience, such as geofencing to trigger a more detailed iBeacon monitoring request?

Our list included a handful of other things that weren’t uncertain from a technical perspective, but could add a significant cost if we chose to build one way or the other, such as caching and queueing locally to allow for nearly-full offline use, or how much we could squeeze out of the third party APIs we were using versus replicating the logic on our API or, worse, mobile application.

Our biggest uncertainties:

* Location services:
* Impact on battery life
* Accuracy - will we need iBeacons and geofencing? GPS? Just one?
* Possible bad network connection in/near store
* Submitting order regardless of app state (in or out of memory, foreground or background)
* Integration with third party kitchen software
* Dynamic menu content, including additions/removals of menu items
* App store release process and timing

## Assumptions & Tools

Alongside our list of uncertainties, we discussed at length what our assumptions were. At One Design, we often call this our “not list”, which includes things like which browsers/OSes we don’t intend support, mainly to bring anything up as early as possible with the client to avoid uncomfortable issues down the road. 

We discussed the tools and technologies we’d use as our foundation, keeping it as simple as possible, yet providing as much flexibility as possible as the project developed.

The project has a number of moving pieces but we kept things as simple as possible to reduce the number of risks introduced into the project: an iPhone application that talks only to our API, which communicates with a handful of other services, including some we’d worked with before and other we had not. We ultimately used iBeacons as a means to trigger the order firing process, but we weren’t certain at the start.

The mobile application was also kept pretty lean. iOS only for now, we used RestKit to communicate with our RESTful API, ReactiveCocoa to handle app state changes, and an elegant MVVM architecture. Aside from the fact that we were using Apple’s still very young Swift 1.0 instead of the more traditional and time-tested Objective-C, the app was pretty much as you’d expect.

We opted to build our API in Ruby on Rails, for three reasons: first, there was a good chance there’d be a web component in the future, and this would prepare us for that; second, the third parties we needed to interact with had decent support with Ruby gems; finally, and perhaps most importantly, our team was comfortable getting a Rails app set up and running with very little effort.

To make sure we understood how the app would affect the other side of the transaction, we spent a few hours in the restaurant watching how orders moved from the front of the house and through their kitchen, noting what information the line chefs needed and what would be a distraction. This allowed us to learn about kitchen operations and the neccessary syntax to communicate with our client effectively.

## Manageable Sizes

The next step was to break down the application into more manageable pieces so we could best figure out who should build what and when. This is the easiest step in any project to dismiss or wave your hands at, but it’s arguably the most important. The goal is to find high level components of the system that are as independent from each other as possible. 

**Dependencies**

Identifying dependencies - things that cannot be built without other some other component - is a key aspect of this break-down process.

For example, let’s consider one component of the system the process to place an order: the app should notify the API to send order details to the third party kitchen software. Before we can send orders to the third party API, we need a way to get the right IDs for products, and presumably their prices so we can calculate tax and the total. 

However, although this eventually will require payment information, we can easily fake payment information while we make sure the actual ordering process is reliable. In fact, if we send the same order data every time, we could avoid various components of that otherwise complex process and add them in one at a time – we could hard code menu item IDs, calculate the subtotal, tax, manually, etc.

**Future-proofing**

Finally, we looked at each of these components and considered their minimal implementation as compared to how they’re likely to change. This is an important part of any engineering planning, but for a project this big, it’s especially important because even within the project scope, it’s likely to change.

For example, we needed to be able to eventually support multiple locations for this restaurant. But for earlier versions, we only were building to support their flagship location. As we built location-specific things, we needed to keep this in mind, without building overly complex software. In our case, this meant building a Location model from which everything stemmed – menu data, pricing, iBeacon information, etc – but didn’t at first worry about how the user would choose a location, or what would happen when s/he switched to a different one.


## Minimum Viable Product

Once we’d broken the project into pieces, analyzed the biggest unknowns and discussed our assumptions, it came time to think of the quickest way to make something entirely useful, even if incomplete. The smaller this product, the better – it means we can release a product sooner to verify our assumptions, it means we could theoretically stop development without wasting a significant amount of effort, and it means we aren’t dealing with hundreds of unfinished components.

**Version 0: Location monitoring**

We opted for our first product to solely put to rest one of our biggest concerns: how and when to determine if the user is close enough – but not too close! – to the restaurant.

**v0.0.1: Location monitoring**

We built an app that did nothing but monitor for a known iBeacon, and send a notification when it was within range (and again when it left). This turned out to be perfect as a first release because such a simple task required quite a bit more: we had to setup the git repository, the Xcode project, establish an organization for our client on iTunes Connect and developer.apple.com, validate signing certificates, etc. It also laid the groundwork for getting the client comfortable with our deployment process through TestFlight.

**v0.0.2: Location monitoring, with a twist!**

Next step was to add the ability to enable and disable the monitoring. This way, we could keep an eye on battery life and learn early on if there was any strange behavior with turning the monitoring on and off. Meanwhile, we had people testing the location monitoring from 0.0.1, by noting how far away they were when they received notifications.

We learned:

* Typically the app would register as “inside” the beacon region about 100ft away
* The proximity of the beacon would change from “far” to “near” about 20ft away, and to “immediate” within a foot or two
* The region was slightly different by device, but not significantly
* Monitoring was significantly impacted by obstacles, so placement of the beacons would be critical

**v0.0.3: Location monitoring Notifying the API**

While the app development for the previous two “releases” was underway, we were chugging along on getting the API set up and running, going through a similar process of building to solve a problem or answer a question each step of the way. This was important, because it meant that at 0.0.3, the app had an API to connect to. For this version, we made the API return an iBeacon’s UUID to monitor, and we created a fake, always-successful, endpoint for the app to contact when it entered the region (to simulate firing the order). In the end, we’d accomplished two things with this release – verify if network latency was an issue, and make it easier to change iBeacon settings without requiring a release – and had gone one step further in building our app.

While this development was underway, all of our testers were able to keep an eye on battery life, and how it changed from the previous release, which monitored constantly.

## Analyze

After about a week, in only three, simple releases, we had answered a whole slew of questions, and had laid the foundation for the app. 

* We had an actual application that we were able to release to internal users/testers
* We had verified that iBeacons were indeed the right technology to use (and were able to spend some time tweaking them to find the sweet spot in the restaurant)
* We confirmed that iBeacons hardly put a strain on iPhone batteries at all, but it was easy enough to optimize and only monitor as needed
* We had the app authenticating using basic auth, which protected our API from malicious users, but realized we’d need user-specific authentication as well, to protect everyone’s accounts from other users

## Rinse & Repeat

By this time, our API team had discovered something pretty important: working with the third party API was increasingly difficult, due to unreliable documentation and less-than-useful error messages. So, we couldn’t get started on browsing the menu or submitting orders, because we still weren’t fully able to read the information we needed. This slightly changed our course, and our focus for the next few iterations became integrating with their API.

**First release, aka “The Coffee App”**

When we started the project, we weren’t sure what our first minimum viable product would be, by continuing this iterative approach – identifying questions or features, building, analyzing, then repeating – we ended up with a stable, albeit simple, application that was able to take a user’s payment information and place an order for a drip or an iced coffee. 

Because we had a little extra time, we added the ability to modify the coffee by choosing a size and whether to leave room for cream. This addressed one of our other concerns – would the third party’s understanding of product modifiers differ from ours? (We probably would have benefitted from making this first full release a bit smaller, perhaps by only allowing one kind of coffee, or maybe by allowing the user to choose ice or drip, but not size.)

Only a few weeks into the project, we had answered nearly all of our concerns, had not wasted any time building features we didn’t yet need (or at least very few), and we were all walking around with a beautiful app in our pockets. 


## To be continued…

Our process is still continuing this way, carefully breaking down components and evaluating what would be the greatest benefit with the lowest cost along the way. When we come across issues, we can evaluate if it’s more or less important than whatever is next in the queue and address accordingly. The client always has a solid idea of what we’re working on, and it’s very clear to our testers what is new in each release. And if ever a release is delayed, the code being held back is minimal. 

Today you can order from the full menu at Eastman, as you would in the store (we put avocado on everything). While you think about how you could apply this process to your next project [download it from the app store](https://itunes.apple.com/us/app/eastman/id986029894?mt=8) and get your self a hot cup of coffee, ready once you arrive.
