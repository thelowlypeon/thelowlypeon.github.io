---
layout: post
title: "Routing Collision with Craft's Action Request"
date: 2015-12-17 15:02:00 -0500
categories: craft routing development
---

We recently started working on a Craft plugin, with which a third party API would contact a single endpoint of our application and make one of two requests (effectively `GET` or `POST`). In the very early stages of development, we were able to hit our custom routes, but tests were failing.

After a bit more digging, we identified the problem: the example payload sent by the third party API included a parameter `action`, which our application would use to identify whether the request was getting data or posting it. When the `action` parameter was set, we'd receive a 404 or a bizzare message that an "id" was not set.

## Requirements

* We cannot change the `action` parameter sent by the third party API
* We cannot identify whether the request sent by the third party is conceptually a GET or a POST except by the `action` parameter
* Ideally, we'd be able to use a clean, case-insensitive URL for the third party API to hit

## Before

We had registered our custom routing in our plugin using the hook [`registerSiteRoutes()`](https://craftcms.com/docs/plugins/hooks-reference#registerSiteRoutes):

```
public function registerSiteRoutes() {
    return array(
        'pluginHandle/process' => array('action' => 'controllerName/process')
    );
}
```
 
And our controller, at this stage, was remarkably simple:
 
```php
<?php
namespace Craft;

class PluginHandle_ControllerNameController extends BaseController {
    public function actionProcess(array $variables=array()) {
        echo 'success'; exit();
    }
}
```
 
When we'd hit the route `/pluginHandle/controllerName/process` in a browser, we'd see the string "success". But if we hit the same route with an `action` parameter, `/pluginHandle/controllerName/process?action={thirdPartyAPIAction}`, we would get an error.

## After

tldr; We couldn't use Craft's custom routing in our plugin, and instead had to treat our request as an action request. Specifically, we had to change our route from `pluginHandle/process` to `actions/pluginHandle/controllerName/process`, and remove our custom routing defined in `registerSiteRoutes()`. This prohibits the flexibility we were hoping for, but avoids modifying the core Craft (or Yii) routing framework.

## Why

All Craft requests are routed through the class `\Craft\WebApp` after bootstrapping most of the framework, which runs several sanity checks and checks or initializes configs, before identifying the request and processing it. Specifically, this checks for the Craft license, initializes the logger, looks for pending database migrations, validates the user session, checks versioning, and so on. When it comes time to process the request, `WebApp` runs a series of checks to identify what kind of request it is, and the order in which it runs is the source of our issue:

1. Is the request a control panel ("Cp") request?
2. Is it an [action request](https://craftcms.com/docs/routing)?
3. Parse the URL, and call `registerSiteRoutes()` hook to include plugins' routes
4. Does the request match a specific controller?

This made it clear why our route was being ignored -- Craft was identifying our route as an action request in step 2, so our custom routes were never actually registered because it never got to step 3.

We dug further into how step 2 worked, and found that it was identifying action requests as:

* a. If the first segment matches `craft()->config->get('actionTrigger')`
* b. If there is a parameter `action` and it is not null (here we go!)
* c. If it is a special path, such as logging in, logging out, setting passwords, etc

So we knew that if our problem was happening in step 2b, we'd need to get Craft to handle our route in either step 1, or step 2a.

We couldn't use step 1, because this request is _not_ a Cp request, which left us with 2a: we needed to make the first segment match the `actionTrigger` config. Once we identified that, we were quick to realize we needed to change our request to behave like an action trigger, which has pretty specific routing requirements. 

## So

In the end, we found a route that works, but it's a little worrisome that Craft uses such a generic word to drive so much of the site's functionality. Hopefully in a future release, Craft will change this to use a more specific, or customizable word, or even something like `_action` to imply that it is a reserved parameter.
