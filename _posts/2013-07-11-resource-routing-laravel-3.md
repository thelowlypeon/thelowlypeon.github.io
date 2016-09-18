---
layout: post
title:  "Resource Routing with Laravel 3"
date:   2013-07-11 09:47:42 -0500
categories: php laravel web
redirect_from: /post/55174735020/resource-routing-laravel-3
---

I've been working on a side project recently using [Laravel](http://laravel.com), the “PHP framework for artisans". It’s a fantastic framework, based largely on concepts from Rails, except more flexible and not as snobby. Laravel 4 was released not long ago, which has some really excellent features, but after spending a full day attempting an upgrade, I made little enough progress that I had to `git reset --hard HEAD`.

One of the things that first drew me to Laravel was its routing. Unlike more traditional MVC frameworks, Laravel adds a new dimension by having a file that is exactly as useful as you want it to be — you could have nearly all of your application logic in the routes.php file, or you could merely tell it to use your controller functions if you’re more comfortable with a traditional, CodeIgniter type approach.

For example, if you have a route for displaying a specific resource, say, a _project_, you declare it like so:

`Route::get('projects/(:num)',array('as'=>'project','do'=>function($project_id) { 
    //do some stuff
}));`

Then, elsewhere in your application, you needn’t remember the actual path to a project, but simply call the route “project" and pass it the $project_id as a parameter.

This is remarkably useful:

*   You can change the URI to the “project" route by modifying only one line of code
*   You don’t need to remember complicated routes, or if you used "/new" or "/create"
*   Very simple routes, which only return a view, don’t require a controller

Another neat part of routes in Laravel is its filtering: for each route, you can add a filter to run before or after a route is executed. For example, if a bunch of routes require your user is logged in, you can create a filter that returns a redirect for users who are not logged in. That way, you needn’t check that the user is logged in for _every single controller function_, nor do you need to keep track of what requires being logged in and what doesn’t. You simply put all of your authorized routes into a group, and for that group, call an authorized filter before any of those routes are executed.

* * *

The project I’ve been working on is pretty straighforward. Most of the resources are nested — there are _projects_, and each project has a number of _jobs_, and each job has a number of _crew_ assigned to it, etc. This means that the URIs look something like this:

*   `/projects/` (all projects)
*   `/projects/{$project_id}` (one project)
*   `/projects/{$project_id}/jobs` (jobs on that project)
*   `/projects/{$project_id}/jobs/{$job_id}` (one job on that project)

Permissions are also nested — a user cannot view a job that belongs to a project he is not authorized to view, for example.

That means that for every route with a {$project_id} specified, we need to verify that the user is authorized. If he is not authorized, we should return a message with a 401 (unauthorized) response code. If the project doesn’t exist, we should return a 404. If he _is_ authorized, we should continue to do whatever we need to.

Likewise, for any route with a {$job_id} specified, we should do the same, except _also_ check its parent project.

To accomplish this, I created four routing filters:

*   `view_project` - checks to see that the user has at least view permissions on the project
*   `edit_project` - checks to see that the user has edit permissions on the project
*   `view_job` - checks to see that the user has at least view permissions on the job (does not check the project)
*   `edit_job` - checks to see that the user has edit permissions on the job (does not check the project)

Then, in our routes.php file, we daisy chain the filters for each group:

<pre>    /**
     * Require UPDATE permissions for a specific project
     */
    Route::group(array('before'=&gt;'authorize|active|edit_project|project'),function() {
        Route::get('projects/(:num)/edit',array('as'=&gt;'edit_project','do'=&gt;function($project) {
            return View::make('projects.form',array('project'=&gt;$project,'client'=&gt;$project-&gt;client));
        }));
        Route::post('projects/(:num)/edit',array('as'=&gt;'edit_project','uses'=&gt;'projects@edit'));
        /* ... */
    });
</pre>

Our `edit_project` filter, as discussed above, looks like this:

<pre>Route::filter('edit_project', function() {
    $param = Request::route()-&gt;parameters[0];
    $project_id = Project::id_from_variable($param);
    $auth = Authorized::project('update',$project_id);
    if( !$auth ) {
        $project = Project::find($project_id);
        if( $project ) { //no auth, but project exists
            return Redirect::to_route('project',$project-&gt;id)-&gt;with('alert','You are not authorized to edit this project');
        } else {
            $view = View::make('error',array('error'=&gt;404,'message'=&gt;"Project not found"));
            return Response::make($view,'404');
        }
    }
});
</pre>

Very simply, the filter looks for a project with an ID in the first parameter, and calls to see if the user is authorized. If $auth comes back false, we check to make sure the project exists, and return the appropriate message. Else, we don’t return anything, allowing the route to continue.

* * *

An astute observer, however, may notice that we’re hitting the database _twice_: once to check if the user is authorized, and once again (if he’s not) to make sure the project exists.

But wait! We’ll need to _re_construct that project later on to actually do what we need to do! Further, what a pain to need to find the project for every single controller method (and, because we’re good people, handle it if the project doesn’t exist). And that’s where resource routing comes in.

Laravel 4 comes with a bunch of this already taken care of, and is pretty flexible in handling various errors. But it’s not too hard to do in Laravel 3 too.

You’ll notice above that we’re grabbing the $project_id in the filter by looking at the route’s first parameter, `Request::route()->parameters[0]`. If we’re careful and clever, we can take great advantage of this by re-assigning the first parameter to a project object, not just the ID. We just need to add one more line, and mode the `$project` assignment out of the `if:`

<pre>Route::filter('edit_project', function() {
    $param = Request::route()-&gt;parameters[0];
    $project_id = Project::id_from_variable($param);
    $project = Project::find($project_id);
    $auth = Authorized::project('update',$project);
    if( !$auth ) {
        if( $project ) { //no auth, but project exists
            return Redirect::to_route('project',$project-&gt;id)-&gt;with('alert','You are not authorized to edit this project');
        } else {
            $view = View::make('error',array('error'=&gt;404,'message'=&gt;"Project not found"));
            return Response::make($view,'404');
        }
    }
    Request::route()-&gt;parameters[0] = $project; //bingo!
});
</pre>

Now the route’s first parameter is a project object:

<pre>class Projects_Controller extends Base_Controller {
    public $restful = true;

    public function post_edit_project(Project $project) {
        //yay! $project is already of type Project!
    }
}
</pre>

* * *

And that’s how we can make resourceful routing with Laravel 3.
