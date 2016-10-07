---
layout: post
title: "Purging Cloudflare Caches"
date: 2016-10-07 13:14:56 -0500
categories: technology cloudflare automation bash
---

**tldr;** Automatically purge Cloudflare caches with [this script](https://raw.githubusercontent.com/thelowlypeon/dotfiles/master/bin/purge-cf-cache).

<hr />

When I [rewrote this site as static HTML](http://cloudflare.com) (generated using Jekyll), it seemed only natural to start caching it entirely.
And because I'm using [Cloudflare](https://cloudflare.com) to enable secure connections (because Github Pages doesn't), it seemed only natural to _also_ use Cloudflare's caching.

Cloudflare seems to update their cache pretty regularly, so at times I'd push changes up and wait, and within a couple hours, the changes would be published. Most of the time, though, I'd log into Cloudflare and manually purge the cache. And because the site is pretty small, purging and regenerating the cache didn't take long at all.

A full deploy with this Jekyll + Github Pages + Cloudflare setup looked like this:

1. Write/edit the post
2. Run `jekyll serve` to preview it
3. Commit the changes, then push to `origin` (github)
4. Wait for Github to build the site (usually less than three seconds)
5. Login to Cloudflare and purge the cache

That fifth step was really bugging me. It seems like something that should be completely automated (and no, there are not currently any Github integrations for this).

So I wrote a script! Yay!

## Installation / Usage

Just download [this script](https://raw.githubusercontent.com/thelowlypeon/dotfiles/master/bin/purge-cf-cache), [get your API key](https://www.cloudflare.com/a/account/my-account), and run `purge-cf-cache`.

Running the script with the `-h` flag will show you options:

```bash
Usage:
  purge-cf-cache [-s sitename] [-z zoneid] [-e cloudflare@email.com] [-k cloudflare_api_key]

Options:
  -z     The Cloudflare zone. This is required if no site is found or defined.
  -s     Site name, eg mysite.com.
         This is not required if a zone is defined.
         Alternately, add a file called CNAME to your working directory with only the site name.
  -e     The email address associated with your Cloudflare account.
         You can optionally declare this as the environment variable CLOUDFLARE_EMAIL.
  -k     Your Cloudflare API key.
         You can optionally declare this as the environment variable CLOUDFLARE_API_KEY.

Example usage:
  purge-cf-cache -s mysite.com -e myemail@email.com -k apikey
```

**Pro tip!** If you're using Cloudflare for a Github Pages site using a custom domain, you likely have a `CNAME` file in the root of your project, so you needn't worry about the site or zone.

**Another Pro tip!** Export your API key and email as bash environment variables and you don't need to pass anything to the command at all!

And there you have it! Now my steps for publishing are:

1. Write/edit
2. Preview
3. Commit, then push
4. Wait a little while
5. Run `purge-cf-cache`

## How it works

The majority of the script is validating the three variables needed to purge: your email address, API key, and "zone" (or, if the zone is unknown, it'll find it from the site).

Other than that, the meat of the script is [a simple CURL call](https://github.com/thelowlypeon/dotfiles/blob/370815115c137446efd8f4decd373d387a7fdd83/bin/purge-cf-cache#L98-L102):

```bash
curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$zone/purge_cache" \
  -H "X-Auth-Email: $email" \
  -H "X-Auth-Key: $key" \
  -H "Content-Type: application/json" \
  --data '{"purge_everything":true}'
```

