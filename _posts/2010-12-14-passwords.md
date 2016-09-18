---
layout: post
title:  "Passwords"
date:   2010-12-14 12:00:00 -0500
categories: passwords security technology
redirect_from: /post/41553345903/passwords
---

Unless you're part of Google's "[Opt-out](http://www.theonion.com/video/google-opt-out-feature-lets-users-protect-privacy,14358/)", you probably spend a bunch of time on the internet, and thus give your private information to a handful of websites. The battle of internet security is, for many, constantly finding the balance between convenience and security/privacy — you _could_&nbsp;have this website store your credit card information for your next visit, but do you want to risk that? Browsing the web safely can be both — but you need to know what you're up against, and how to protect yourself.

![image](http://farm1.static.flickr.com/177/378558597_bfcbbb8c2e_m.jpg)

**What good is encryption?**

Using 128 bit AES encryption — meaning if you use one of the most common encryption algorithms and a "key" that is enormous — it is fairly safe to say that no one could decrypt your message in the foreseeable future. The US government uses 256 bit encryption, which would theoretically take 3×10<sup>51</sup> years to decrypt using brute force.

But this all falls apart if your password is "hello".

Using "brute force" — simply trying all one character passwords, then all two character passwords, then all three, and so on — a typical desktop PC can crack a password of six letters and numbers in a [pathetic 36 minutes](http://geodsoft.com/howto/password/cracking_passwords.htm). Add capital letters and it becomes a day and a quarter. Add an extra character, bringing it to a length of seven, and it would take 2.83 months. Nine characters will take 1.12 millennia.

But the amount of time quickly drops to zero if your password is "hello".

Suppose you have a really solid password — capital letters, numbers, ten characters, the works — but you use it at an unsecure website. These sites aren't as uncommon as you may think: forums you frequent, your buddy's blog, or a newspaper. You don't give these sites any important data, no credit cards or addresses or private conversations, so you're not too worried about that site being hacked into.

But suddenly your secure data is available because you used the same password on every other site.

**Secure vs Unsecure**

Modern browsers make knowing the difference between a secure site and an unsecure site easy. A "secure" site is one that uses encryption to send data between your computer and their servers. These sites get a certificate, called and "SSL Certificate", through a third party, which assures that the site is who they say they are. A secure site often has a padlock, and the address begins with "http**s**://"; an unsecure site will only have "http://":

1.  Secure:![image](http://www.20thingsilearned.com/media/illustrations/url_b4.png)
2.  Unsecure:![image](http://www.20thingsilearned.com/media/illustrations/url_b2.png)

The most important thing to check, with nearly every page load, is the URL, or address, of the page you are looking at. If you receive an email from your bank with a link to provide your login credentials, you should _always_&gt; check the URL when the page loads. A page can _look_ like your bank's page, but really be someone malicious trying to steal your credit card number. Never give any information to any page if the URL isn't one you recognize. Google wrote a great site called [20 Things I Learned](http://www.20thingsilearned.com/)&nbsp;with a clear explanation of [how to use the web address to stay safe](http://www.20thingsilearned.com/url/1).

**The Frightening Reality**

You may have heard that earlier this week, [Gawker's servers were breached](http://thenextweb.com/media/2010/12/13/gawker-hackers-release-file-with-ftp-author-reader-usernamespasswords/), releasing all their data to the public, including commenters' email addresses and password, private internal conversations, and emails. A notification I received from Gawker stated:

> This weekend we discovered that Gawker Media's servers were compromised, resulting in a security breach at Lifehacker, Gizmodo, Gawker, Jezebel, io9, Jalopnik, Kotaku, Deadspin, and Fleshbot. As a result, the user name and password associated with your comment account were released on the internet.

The attack is theorized to have been orchestrated by someone with the alias 4Chan, who had been feuding with founder Nick Denton, who is increasingly reputed as using unethical tactics to generate web traffic. And while I don't frequent any of his websites, and confirmed that my information was [_not_&nbsp;released](http://gawkercheck.com/), the attack shook me up, in part because of two oddly timed notifications I received around the same time:

*   My Facebook account was accessed from a computer in India
*   My iTunes account detected new visits from a "new device"

I had a similar scare a few months ago, which prompted me to change all my passwords and purchase the very much loved [1Password by Agile Solutions](http://agilewebsolutions.com/onepassword), a way to securely store your passwords on your local machine (or iPhone or iPad). I devised what I thought was a good strategy for keeping passwords safe on the internet. I had three passwords:

*   One for secure websites
*   One for unsecure websites
*   One for websites where security is incredibly important, like online banking.

This strategy had two enormous problems:

*   As noted above, even secure websites can be attacked
*   I got lazy and soon found myself using my "secure" password all the time

And since the Gawker attack, I've rethought my strategy.

**Safe Passwords**

There are a few rules which I strongly recommend you follow when creating and providing passwords for various websites. Unless you have a great memory, you may consider purchasing something like [1Password by Agile Solutions](http://agilewebsolutions.com/onepassword)&nbsp;to store your passwords. They have an iPhone and iPad app too.

*   Randomly substitute letter for numbers that look or sound similar. This will be easy to remember, but are much more difficult for a computer to detect. For example, instead of &nbsp;**peter** use &nbsp;**p3t3r**, or instead of &nbsp;**iatebananas** use&nbsp;**18bananas**.
*   Rather than using words, consider using the first letter of each word in a sentence. These are often easier to remember, and are _really_&nbsp;hard to find using brute force. Make a password like "mniPur2" for "my name is peter you are too".
*   Capitalize random letters. This increases time to hack a 7 character password [from 2 hours to 2 years](http://avalantern.com/thelowlypeon/links/2010/04/14/How-Id-Hack-Your-Weak-Password).
*   It's a pain, but it's very important to use different passwords for different sites. If this is too difficult to remember, simply take your good, long, weird password, and add something to it for each site. For example, you could prepend the second letter of the site to your password. If your password is mniPur2, when you log in to Google, use the password omniPur2.
*   Don't write your passwords on a post-it note next to your computer. (I can't recommend 1Password enough.)

Many sites nowadays have a test to show how strong your password is. These are a great way to make sure your password isn't easily identifiable.&nbsp;

**Conclusion**

Staying safe on the internet isn't as difficult as people may say, you only need to remember a few basics. And like anything else, always use care when giving information to someone. Just as you'd never give your social security number over the phone to someone who hasn't identified himself properly, you shouldn't give it to a website you don't trust.

—

_Code image by [Luciano Bello](http://www.flickr.com/photos/lbello/378558597/), used under Creative Commons. URL images by Google on [20thingsilearned.com](http://www.20thingsilearned.com/)_

_Additional reading at:_

*   [LifeHacker.com](http://lifehacker.com/5505400/how-id-hack-your-weak-passwords)
*   [GeodSoft.com](http://geodsoft.com/howto/password/cracking_passwords.htm)
*   [TheNextWeb.com](http://thenextweb.com/media/2010/12/13/gawker-hackers-release-file-with-ftp-author-reader-usernamespasswords/)

*   [CodingHorror.com](http://www.codinghorror.com/blog/2010/12/the-dirty-truth-about-web-passwords.html)

*   [Dekart.com](http://www.dekart.com/howto/howto_disk_encryption/howto_recover_lost_password/)

*   [Avalantern.com](http://avalantern.com/thelowlypeon/links/2010/04/14/How-Id-Hack-Your-Weak-Password)

*   [Wired.com](http://www.wired.com/science/discoveries/magazine/17-05/ff_kryptos)
