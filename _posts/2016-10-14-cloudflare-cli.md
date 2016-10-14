---
layout: post
title: "Cloudflare CLI"
date: 2016-10-14 15:02:56 -0500
categories: technology cloudflare automation bash
---

About a week ago, I added a simple script to my environment to make it easier to purge Cloudflare caches. Read more about it [here](/2016/purging-cloudflare-cache).

But it was a wee bit too simple: I didn't want to check my API keys into any repo, and I also didn't want to keep it lying around so I could pass it in as an option.

And **Behold!** 

## [Cloudflare CLI](https://github.com/thelowlypeon/cloudflare-cli)

I improved the script to make it so you can easily store your config locally. Now, your API key, email, and site-or-zone can be stored locally as:

1. Environment variables
2. Flags (as before)
3. In a `Cloudfile` at the root of your project

And the site name can be stored in a `CNAME` file, which is already required for Github pages sites with custom domains.

I added it to [my dotfiles](https://github.com/thelowlypeon/dotfiles/tree/d68b6e48eaa025c58bbca8758f365c49557d21b2/lib) install script where it's [symlinked to `cloudflare`](https://github.com/thelowlypeon/dotfiles/blob/d68b6e48eaa025c58bbca8758f365c49557d21b2/bin/cloudflare), making it easier to type and remember.

Check it out on Github!

## [github.com/thelowlypeon/cloudflare-cli](https://github.com/thelowlypeon/cloudflare-cli)

Right now its functionality is limited to fetching your site's zone and purging the cache. Feel free to fork it and make it better! 
