---
layout: post
title:  "Fibonacci or Phi?"
date:   2012-10-30 12:00:00 -0500
categories: math fibonacci phi
redirect_from: /post/41556640993/fibonacci-or-phi
---

Last night, as Hurricane Sandy was growing ever more fierce, a friend of mine posted a satellite photo of the storm with a spiral laid out over it:

[](https://twitter.com/2cogitate/status/263068338186510337)
[![image](https://pbs.twimg.com/media/A6abQoGCYAAeXuK.jpg)](https://twitter.com/2cogitate/status/263068338186510337)

We've all seen this spiral before — in galaxies, sunflower seeds, snail shells, and, unfortunately for the universe, in the movie [The Davinci Code](http://www.imdb.com/title/tt0382625/).

In high school, I became obsessed with mathematics for one reason: the irrational number 1.618033..., also known "the golden ratio" or "the golden mean", and only within the last hundred years or so, the lower case Greek letter φ (phi, pronounced "fee"). The number has unbelievable properties, enough that I've been shunned from parties for talking about them, gotten into arguments about its merits as compared to the far lamer π (pi). A single example of its mathematic beauty:

φ (phi) is defined by the solution of _x_^2 = _x_ + 1, which means:

*   φ (phi) = 1.618033...
*   φ (phi) ^ 2 = 2.618033...
*   φ (phi) ^ -1 = 1 / φ (phi) = 0.618033...

Another example was discovered by a guy named Roger Penrose. Called [Penrose Tiles (kites and darts)](http://en.wikipedia.org/wiki/Penrose_tiling), if you take two shapes, each with two sides of length 1 and two sides of length φ (phi) and piece them together infinitely, you will have a set of random patterns whose ratio of one shape to the other approaches this magical number φ (phi). I have this tattooed on my ankle.

Now that I've mentioned my tattoo, I should also note another neato pattern. If you take 1+1/(1+1/(1+1/(...))), this too will approach φ (phi) with the more values you add. If you were able to keep going on forever writing it this way, it would be equal to φ (phi) (because it's irrational). [My friend's tattoo](http://www.flickr.com/photos/virtualcourtney/433035152/) is of this infinitely looping around her arm.

Meanwhile, there's a sequence of numbers commonly referred to as the Fibonacci sequence. The sequence is insanely simple: start with 0 and 1, and add any two consequtive numbers in the sequence to get the following. So, if you start with 0 and 1:

*   0
*   1
*   0+1 = 1
*   1+1 = 2
*   1+2 = 3
*   2+3 = 5
*   3+5 = 8
*   5+8 = 13
*   8+13 = 21

...and so on. Let's focus for a little while on this sequence, keeping that magical number φ (phi) in our heads.

Let's take any number in the sequence and divide it by the previous number. If we start with 2, this new sequence looks something like 1, 2, 1.5, 1.66..., 1.6, 1.625, 1.615, and so on. You may notice that this sequence jumps around in the beginning, but slowly gets closer to φ (phi). In fact, that's _exactly_ what happens. It gets remarkably close to 1.618033 remarkably quickly.

As much as I'm dying to, I won't go into just how awesome this sequence is. I'll just reiterate how closely related it is to φ (phi).

* * *

Which brings us to last night, when I [tweeted](https://twitter.com/thelowlypeon/status/263071362036428800) the above image with the caption "Fibonacci!". I was quite surprised to find that I got over 80 retweets plus a whole skew of thise quasi retweets. I was also surprised by how many people were correcting me on my "Fibonacci!" exclamation, suggesting instead that it was the "golden ratio" or the "golden mean".

So I took it upon myself to see if the image indeed depicts a golden ratio, meaning a ratio based solely on 1.618033..., or if it is more based on a Fibonacci spiral, which is comprised of adjacent squares of sizes in the Fibonacci sequence.

Let's look at the image again:

[](https://twitter.com/2cogitate/status/263068338186510337)
[![image](https://pbs.twimg.com/media/A6abQoGCYAAeXuK.jpg)](https://twitter.com/2cogitate/status/263068338186510337)

We can see right from the start that the sprial begins with only two squares. This suggests at first glance that this is a Fibonacci spiral, because a true golden spiral would [have no beginning](http://en.wikipedia.org/wiki/Zeno). But, since the image is only 255px wide, we'll assume that was a constraint due to size.

So I pulled out the old [ruler](http://www.pascal.com/software/freeruler/), and the image, and did some measuring, pixel by pixel. Here's what I found:

*   The first square in the sequence is 4x4
*   The second square, too, is 4x4. So far, we're on track for a perfect Fibonacci spiral.
*   For the third square, we know one side is 8 (because the two adjacent are each 4), and the other side is 9. Not exactly a square, probably due to compressing the image.
*   The fourth square is 13x13
*   The fifth is 22x23
*   The sixth is 36x36
*   The seventh is 58x59
*   The eighth is 95x95
*   The ninth looks like it was cropped, so we only have the first 8 to gather data from

If we make these into squares, we roughly get a sequence of 4, 4, 8, 13, 22, 36, 58, 95.

**Let's analyze these numbers in the eye of the golden ratio:**

![image](https://66.media.tumblr.com/da1cff5f55e8c7290d6314a93c7b6e8f/tumblr_inline_mh98ozVuWp1qz4rgp.png)

The average difference per step: 0.225. Not bad.

**And from that of Fibonacci:**

![image](https://68.media.tumblr.com/ac67ec0ef8c656bba476d293617652bf/tumblr_inline_mh98paSvpm1qz4rgp.png)

The average difference per step: 0.0318.

* * *

And so, in conclusion, the spiral depicted in that satellite image of Hurrican Sandy is slightly closer to that of a Fibonacci spiral than to that of a Golden Spiral.

QED.
