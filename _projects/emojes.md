---
layout: project-left
title:  <a href="https://emoj.es">emoj.es</a>
date:   2017-04-02 17:26:32 -0500
categories: silly emoji
image: projects/emojes.png
caption: A silly website that'll take your emoji input and generate a huge "preview" image in chat apps.
more: https://emoj.es
---

In about three hours, while my daughter wouldn't fall asleep, I built a stupid site with one purpose: embiggen your emoji.

Remember at WWDC 2016, when Apple announced that sending three or fewer emoji in iMessage would make them larger? Well, emoj.es is even better.

Send a link to emoj.es in iMessage, and it'll automatically fetch a preview of the page, and the image meta tag will point to a huge image of your emoji.

It's simple: just type `emoj.es/` and enter your emoji. Add another slash and some url-encoded text to see it as the title.

For example:

```
http://emoj.es/😎/oh%20yeah
```

will result in a huge sunglasses emoji with "oh yeah" in the text.

Try it!

Read more at [emoj.es](https://emoj.es)
