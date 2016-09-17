---
layout: post
title:  "Rails 4 Asset Pipeline & jquery-validation-rails Gem"
date:   2013-10-31 10:31:42 -0500
categories: rails jquery assetpipeline gem
redirect_from: /65616664487/rails-4-asset-pipeline-jquery-validation-rails
---

I recently started on a new project with the intention of becoming familiar with Rails 4. The site itself is very simple: it consists of only three resources, and index page that shows a random unviewed resource, a form for the public to submit new data, and an admin controller to approve or reject public submissions.

I came across [this bootstrap + jquery + validate demo](http://alittlecode.com/files/jQuery-Validate-Demo/index.html) and liked its simplicity and I didn't want to reinvent the wheel. So, although I've historically preferred to use LESS CSS, Skeleton CSS, and various icon sets, I decided this time to give Twitter Bootstrap a real try -- something I've done in the past, but have since avoided due to its now too-familiar look and feel and enormous size.

To handle my form validation, I'm using [jquery-validation-rails](https://github.com/danryan/jquery-validation-rails), a gem that simply adds [jquery validation](http://jqueryvalidation.org) to the rails asset pipeline.

The instructions on the site are simple:

#### Add `jquery-validation-rails` to your Gemfile and run `bundle install`:

    gem "jquery-validation-rails"

#### Include jquery-validation-rails javascript assets

#### Add the following to your `app/assets/javascripts/application.js`:

    //= require jquery.validate
    //= require jquery.validate.additional-methods

Simple, right? Well, ```bundle install``` threw no errors, but loading any page did:

couldn't find the file jquery.validate ...

I had a hunch that the gem was simply not compatible with Rails 4. I did some digging but had no success, and after banging my head against the wall decided to investigate how the Rails 4 asset pipeline differs from that of Rails 3. I came across [this little nugget](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html#action-pack):

>In Rails 4.0, precompiling assets no longer automatically copies non-JS/CSS assets from vendor/assets and lib/assets. Rails application and engine developers should put these assets in app/assets or configure config.assets.precompile.

Sure enough, the jquery-validation-rails gem, stored in ```/usr/lib/ruby/gems/1.9.1/gems/```, was placing all its assets in ```vendor/assets```. I tried moving the assets around, and changing the include paths to look for them, and got it to work. But, knowing that any time I ran ```bundle update``` things could break, I decided instead to just directly grab the [jquery validation js](http://jquery.bassistance.de/validate/jquery-validation-1.11.1.zip) and throw it into my site's ```vendor/assets/``` directory instead.

_UPDATE (2014-02-03)_

This was addressed [a few weeks ago](https://github.com/danryan/jquery-validation-rails/commit/07ec50683c96c81e62ddae41a3b6eb151e632868) and looks like it's all fixed. Thanks for the update, Lasitha!
