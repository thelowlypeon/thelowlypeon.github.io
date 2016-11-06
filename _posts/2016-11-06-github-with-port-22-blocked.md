---
layout: post
title: "Accessing Github When Port 22 is Blocked"
date: 2016-11-06 12:03:49 -0500
categories: technology git github security united
---

I'm on a long haul flight right now from <span title="Chicago O'Hare">ORD</span> to <span title="Shanghai Pudong">PVG</span>,
and was excited for some no-distraction time to get some work done.
(The $16 wifi on United, although slow and its coverage spotty, is worth every penny.)

```bash
$ git fetch
ssh: connect to host github.com port 22: Operation timed out
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

Grr. Port 22 is blocked.
Fortunately, you can access Github over port 443 [easily](https://help.github.com/articles/using-ssh-over-the-https-port/):

In `~/.ssh/config`, simply add:

```
Host github.com
  Hostname ssh.github.com
  Port 443
```

and voila!
