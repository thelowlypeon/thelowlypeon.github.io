---
layout: post
title:  "Be a Real Man or Woman"
date:   2013-12-05 13:48:06 -0500
categories: vim
redirect_from: /post/69095422256/be-a-real-man
---

.vimrc:

```
for prefix in ['i', 'n', 'v']
    for key in ['<up>', '<down>', '<left>', '<right>', '<home>', '<end>', '<delete>']
        exe prefix . "noremap " . key . " <nop>"
    endfor
endfor
```
