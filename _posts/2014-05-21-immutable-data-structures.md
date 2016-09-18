---
layout: post
title: "Immutable Data Structures"
date: 2014-05-21 16:43:16 -0500
categories: data compsci
redirect_from: /post/86440757266/immutable-data-structures
---

I just saw a talk by the great [David Nolan](https://github.com/swannodette) ([@swannodette](https://twitter.com/swannodette)) on how software architecture, namely the MVC design pattern, is "like the great pyramids," which take a long time and lots of manpower, and how we as software architects haven't yet discovered the arch. The DOM, as he succinctly put it, is fundamentally about documents, not about events or views.

He introduced to me an idea that I've known about since Comp Sci 101, but never gave much thought to or truly understood the power of: immutable data structures.

Consider a linked list. Each node contains whatever information it needs, and then optionally has a pointer to another node:

![](/assets/images/posts/immutable-data-structures/linked-list.png)

In the example above, the node A points to node B, which in turn points to node C. If we consider the linked list as a whole, A essentially is, in order, [A B C].

But suppose we built a new node, X, which _also_ points to B:

![](/assets/images/posts/immutable-data-structures/linked-list-with-new-root.png)

Now we have _two_ values, [X B C], and our original, unmodified [A B C]. 

Think about this for a second. We have two lists, each containing three nodes, but the two lists _combined_ take up only 33% more space than either one.

This may not seem all that amazing (yet), but what if, instead of linked lists, we looked at arrays? Consider an array with four elements, each which point to another array of four elements, each pointing to an array of four elements, each which point to an array containing four values:

![](/assets/images/posts/immutable-data-structures/arrays.png)

We can traverse this tree and, with only _four_ calculations, can find any of 256 values. (For more about this, read up on [Phil Bagwell's hash array mapped trees](http://infoscience.epfl.ch/record/64398/files/idealhashtrees.pdf).)

Okay, so that's a fast way to find some values, big deal.

But what if we wanted to _modify_ one of those values? Applying the same idea as we did to linked lists, we can do so by modifying only the four arrays we traverse to get to the value we're changing:

![](/assets/images/posts/immutable-data-structures/arrays-with-path.png)

Further, since this is essentially storing only the diffs, we end up storing only a small percent more for what is essentially a completely different array of values.

[React](http://facebook.github.io/react/) utilizes this to create a virtual DOM, making updating views blazing fast, take up less space, and easy to go back in history (undo).

This probably isn't mind blowing for some of you, but somehow I've gone the last ten or so years without realizing how powerful a data structure so simple can be.
