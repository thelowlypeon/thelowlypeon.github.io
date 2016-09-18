---
layout: post
title: "Temporarily Update Net::HTTP Timeout"
date: 2015-12-02 15:50:56 -0500
categories: ruby nethttp heroku
redirect_from: /post/134420374716/temporarily-update-nethttp-timeout
---

I’ve been working on a project recently that deals with lots of third party data. Well, lots of _unreliable_ third party data. We have a bunch of tasks running to import and massage the data.

This morning when I got to the office, I found that a critical import had failed. I dug through the logs and found it was due to a timeout with the third party service.

Fortunately, for the long term, we’re able to work with the third party to improve the performance of this request. But short term, we needed to urgently run the job, and that meant increasing the timeout.

Our timeout was already pretty high – 50 seconds – so I didn’t want to increase it permanently. Nor did I want to make any commits and push out new code. The job is easy enough to run in the Rails Console on Heroku, but the `Net::HTTP` call is nested pretty deep inside the job.

I looked for documentation on how to increase the timeout, but all the solutions seemed to require modifying the code, which would mean a new deploy. But alas! You can reopen classes in Ruby! I just needed to reopen the class we defined with `include HTTParty`.

So, with `heroku run rails c -a appname`, in the Heroku Rails console, I ran the following:

    > module ThirdPartyLibModule
    >   class Connection
    >     default_timeout 10000
    >   end
    > end
    > ImportantDataImportWorker.new.perform

And boom. Timeout was 10000 seconds, and the job finished, albeit slowly.
