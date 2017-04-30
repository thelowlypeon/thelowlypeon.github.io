---
layout: post
title:  "LXC Containers"
date:   2017-04-02 17:22:44 -0500
categories: linux webservers webdevelopment devops
---

# My Adventure With LXC Containers

Over the last week or so, I've been playing around with LXC containers, low level virtualization containers in Linux. (Specifically, I've been using LXC version 2.0.9 with Ubuntu 16.04, on a cheap Digital Ocean box I setup for my experiment.)

## Basic LXC Usage

### Installation

First, in case you want to play along, installing LXC is incredibly easy:

```bash
$ sudo apt-get update && sudo apt-get install lxc
```

### Handling Containers

Create containers from a given template. For most of my playing around, I used a base `ubuntu` template, but you can find far more with `apt-get install lxc-templates`.

```bash
# lxc-create -n container_name -t template
$ lxc-create -n webserver -t ubuntu
```

Each container lives in `/var/lib/lxc/$CONTAINER_NAME`. Exploring this directory shows how simple a container really is:

```bash
$ ls /var/lib/lxc/webserver
config
rootfs/
```

The `config` is created automatically, as is the root filesystem. By default, containers don't start automatically, but you can change this easily by adding the following to your config:

```
lxc.start.auto = 1
```

Henceforth, you can start your container either by specifying which container to start, or by autostarting all of your containers based on their autostart settings:

```bash
$ lxc-start -n webserver
$ lxc-stop -n webserver
$ lxc-autostart
```

Connecting to your container is easy as pie. Either enter a console session from the host, or setup ssh as you would with any other Linux machine, except that your container is living in virtual private network, and thus only accessible from the host or with some port forwarding.

```bash
# lxc-console -n $CONTAINER_NAME
$ lxc-console -n webserver
```

If you're going to connect to your container remotely often, you may want to setup ssh forwarding. On your local machine, add the following to `~/.ssh/config`:

```
Host my_webserver_host
  User myuser
  ProxyCommand ssh -q host_container  nc -q0 private_local_ip 22
```

Here's what my ssh config looked like:

```
Host host_container
  HostName 123.123.123.123
  User root

Host appname
  User deploy
  ProxyCommand ssh -q host_container  nc -q0 10.0.3.96 22
```

Then I could ssh using `ssh appname` or `ssh deploy@appname`, which would first connect to my host container as a proxy, which would forward traffic to my app container. (Note: I added keys to both machines to avoid dealing with passwords.)

### Notes

* Containers don't autostart by default. Which is good! But easy to forget.
* Containers use DHCP on a virtual private network. You can make it a bit easier to connect by adding a line in `/etc/hosts`, but either way, you'll probably want to set the container's IP to be static if you plan on connecting to it in any way other than `lxc-console` (see update below to connect by hostname)
* Containers use DHCP by default, so if you plan to do this often, you'll want to set your container's IP to be static (in `/etc/network/interface`).
* Containers, by default, use the same filesystem as the host. But you can also set them up to use different filesystems, such as `btrfs`. The benefits [are pretty mindblowing](https://www.flockport.com/supercharge-lxc-with-btrfs/).

## What I Learned

### LXC Containers are pretty incredible.

As a result of my little experiment, I'm running three rack applications on a single host, using a container for each application (which contains _only_ the code base, `rbenv`, and unicorn, running on the only open port other than 22 for ssh), a container for nginx, which forwards requests to the appropriate container by hostname (bonus: I only need to setup pesky ssl stuff once!), and one container running postgres. 

I can easily constrain resources on any container to ensure something going haywire doesn't affect the others. I know each is secure and walled off, so there's no risk that a process on one could, say, overwrite part of another's filesystem, or kill off any processes.

At any given time, I can clone one of the application containers and add it to my nginx `upstream` and I've got built in redundancy, or, if I'd rather move it to a different machine, I can do so easily by exporting the container to a new machine and merely changing my nginx config to look at that IP.

### What I _Really_ Learned

But realistically, this isn't any different than running each of these five services on their own servers. What I _really_ learned was that containerizing web applications has some really tremendous benefits.

Historically I've tended to put all my applications on their own server: each had source code, database, webserver (plus passenger/puma/unicorn for rack apps), a user for sudo stuff, a user for deploys and sometimes running the webserver. For really small websites, I'd setup several as virtual hosts on the same machine. This approach was easy and familiar, and pretty cost effective.

But over the years I've built so many small side projects. In fact, my exploration into LXC containers was because I built [emoj.es](https://emoj.es) (a stupid website that takes emoji and makes them into a big image, so when you share links in chat apps, they'd get a huge image as a "preview", making your emoji nearly full screen), and couldn't justify spending $7/mo for Heroku, or $5/mo for a new Digital Ocean droplet, and it was so stupid a site I didn't want to risk affecting any of my other side projects.

### Docker

Docker is all the rage right now. Probably even moreso than the latest javascript framework that ... wait for it ... _just_ ceased development. Docker takes this containerization idea and automates lots of it. In fact, it sounds like if you know what you're doing, it's pretty incredible. _And_, unlike LXC containers, you can run them on Mac OS X, so your development environment matches your production environment more closely. (It does this by running vagrant and VirtualBox behind the scenes. If you do this yourself, you can run LXC containers locally too.)

I played with Docker for a few hours and learned a couple things, which ultimately resulted in my choosing LXC containers instead:

* Most of the base images everyone uses are marked as vulnerable. That doesn't give me a warm and fuzzy feeling.
* Most of the base images are created and maintained by people who have little incentive to keep them around, which makes me very worried. Worse, they change all the time, so unless you -- and they -- are extremely careful about versioning, you risk small changes in your environment any time you run your deploy. (This is true for just about any package management (side note: a third party library we use at work removed and recreated a tag on github, so the same locked version had different behavior), but particularly scary when you're talking about environments.)
* It took me _forever_ to do basic things. Specifically, I wanted to start with a base Ubuntu image rather than the vulnerable ruby one, and it took me nearly three hours to get a new version of ruby installed. With `apt-get` on ubuntu, the same task took me 15 minutes.
* Docker is _really bad_ about permissions and security. If you're using docker, I highly recommend you check whatever images you're using that you didn't write, and see how much is running as root.

But there's one thing Docker does that my now-beloved LXC containers don't: it automates provisioning and configuration. I tend to do that either as a set-it-and-forget-it because I'm lazy, which doesn't do well over time, or with bash scripts that get grosser and grosser over time. This is better with containerized applications, though, because the steps to configurate a server are fewer and fewer. But it's still a problem I wouldn't consider solved (for me).

## Conclusion

If you like Docker, awesome. If you like LXC Containers, that's awesome(r). If you're like I was, installing the full stack on a single box for your app, then, well, you're livin' in the past, man. I'll never go back.

Moving the components of my application into different containers (whether servers, LXC containers, whatever) made me think more about how they talk to each other, what they need to run effectively, and how to isolate possibly vulnerabilities. For my more significant applications, like the API for [Station to Station](http://stationtostationapp.com), I can have one machine with different containers, which I can easily scale, clone, whatever, as my needs change. Or for my smaller side projects, I can share resources by having a single webserver forwarding traffic to each application, a single database that I can backup or add slaves to, and I can keep costs way down by doing so on fewer machines.

Either way, if you host web applications, this is something worth looking into.

Also, I really love Linux.

## Update

Turns out you can connect to LXC containers by hostname pretty easily.

1. Install `dnsmaq` with `sudo apt-get install dnsmasq`
2. On Ubuntu 16.04, update `/etc/default/lxc-net` to set the top level domain. The default is `lxc`, which you can set by uncommenting the line `LXC_DOMAIN="lxc"`.
3. Restart the LXC net service `sudo service lxc-net restart`
4. Add forwarding by editing `/etc/dnsmasq.d/lxc` and adding `server=/lxc/10.0.3.1` (this is `/etc/NetworkManager/dnsmasq.d/lxc.conf` for Ubuntu 14.04)

Then you can connect using `ssh user@container-name.lxc`, or verify using `dig container-name.lxc`
