---
layout: post
title:  "Fixing httpd.conf in Mountain Lion 10.8"
date:   2012-07-26 12:00:00 -0500
categories: osx apache
redirect_from: /41557124730/fixing-httpdconf-in-osx-mountainlion
---

I've been having some annoying issues with OS X 10.7 Lion, and I had hoped that upgrading to OS X 10.8 Mountain Lion, Apple's newest OS, released just yesterday, would fix some of the problems. Giving my history of upgrading my OS, I should have predicted that upgrading would a) not solve my issues, and b) cause a whole lot more of them.

Unlike my past upgrade woes, this was on the machine I use for development. Thus, this set me back a bit for my work, which is primarily web development. I could have used our development server, but the latency drives me nuts doing that. Anyway, upon upgrading, my localhost was broken. I got a 404 error at any and all of my local virtual hosts (eg [http://localhost](http://localhost), http://mysite.localhost).

**Goals / Requirements**

*   Get my Apache web server running again
*   Get at least two virtual hosts configured, with one being an absolute priority
*   Add a RewriteCond and RewriteRule to the configuration

The research on the interwebs was bleak, seeing as how the OS was released mere hours before I had the issue. I had downloaded Mountain Lion Server, the $20 upgrade for making server management easier (ha!) for my other machine, and decided to install it. I'd heard great things about the web management changes, and figured this could be an opportunity to easily set up several virtual hosts. If not, I figured, I have lots of backups of my Apache configuration file (/etc/apache2/httpd.conf).

After installing Server.app, sure enough, my localhost showed the default. I went through the absurdly simple steps to setup a virtual host (a "custom website"), knowing full well I'd have to do some tweaking later on (namely for the RewriteCond and RewriteRule, which I assumed Apple's ultra simplified UI would not leave room for).

After a bunch of nitpicky changes, I was able to make my "custom site" show up at http://mysite.localhost. I foolishly assumed it was because I had replaced the file at /etc/apache2/httpd.conf with my old one. Oddly, none of the other virtual hosts I had set up http://myothersite.localhost worked — they all pointed to the default Apple site that tells you how great Server.app is.

And then several hours later, I figured it out. It's no longer stored at /etc/apache2/httpd.conf. For some reason, Apple has changed something that's worked for a long time, and instead created a whole bunch of files in /Library/Server/Web/Config/apache2/sites. There's a .conf file for anything on port 80, another .conf file for the site I created in Server.app, and a whole bunch of other backups made for every change I made in Server.app.

So I was able to get the RewriteRule and RewriteCond to work by modifying the file called 0000_any_80_mysite.localhost.conf.
