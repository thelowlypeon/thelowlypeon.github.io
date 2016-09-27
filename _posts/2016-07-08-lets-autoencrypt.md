---
layout: post
title: "Let's Auto Encrypt"
date: 2016-07-08 09:31:00 -0500
categories: ssl security web
reposted_from:
  site: the One Design Company blog
  url: https://onedesigncompany.com/news/lets-auto-encrypt
  date: 2016-07-08
---

We're big fans of [letsencrypt](https://letsencrypt.org) here at ODC.

Let's Encrypt is a new kind of certificate authority. Rather than making you wait for approval and demanding a bunch of money like authorities in the past, Let's Encrypt provides an automated tool to run on your server to generate secure SSL certificates, allowing us to serve websites over https in a matter of minutes.

So, not only do they make our lives much easier as developers, by making it incredibly simple to add SSL to any website, but they make our lives much more secure as consumers by encouraging everyone else to do the same.

However, certificates issues by Let's Encrypt expire after three months, which is quite a bit sooner than those of the old days which lasted for a year or more. With the ease of generating these certs, and their short lifespan, it didn't take long for us to realize we needed a solid means for auto renewal.

(There's plenty of great documentation for how to _install_ a Let's Encrypt certificate, so this post focuses only on automatically renewing existing certs.)

## Certbot

Recently, Let's Encrypt began to recommend using the [`certbot`](https://certbot.eff.org) client for setting up certificates. Installing `certbot` is incredibly simple. We use Apache on Debian for many of our projects, which is covered by their `auto` tool, so we need only to run:

```bash
$ wget https://dl.eff.org/certbot-auto
$ chmod a+x certbot-auto
```

Then, to renew our existing certs, we can run:

```bash
$ ./path/to/certbot-auto renew
```

## Cron

Now we just need to automate that command. We created a simple bash script that logs the time, updates our certs, and then restarts Apache gracefully:

```bash
#!/bin/sh
echo "\n\n`date -u`" >> /path/to/logs/certbot.log
/path/to/certbot-auto renew --force-renewal --no-self-upgrade >> /path/to/logs/certbot.log
sudo apachectl graceful
```

Finally, although LE certs last for three months, we opted to renew them monthly to make it easier to catch issues with enough time to fix it. (Let's Encrypt will skip renewal if it deems it's too soon, so we throw the `--force-renewal` flag in there to force it.) So, we threw the script, `renew-certs`, into `/etc/cron.monthly/`, updated its permissions (this is important!):

```
$ cp renew-certs /etc/cron.monthly/
$ chmod +x /etc/cron.monthly/renew-certs
```

To make sure Debian noticed, we can test using `run-parts --test`, which takes the directory you're checking:

```
$ run-parts -v --test /etc/cron.monthly
/etc/cron.monthly/renew-certs
```

(You can manually run the cron by omitting the `--test` flag.)

And there you have it! An automated process for renewing your letsencrypt certs every month!
