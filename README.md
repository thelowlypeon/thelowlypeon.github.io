# Peter Compernolle

This is my site! Welcome.

## Deployment

This is a Jekyll site, built and hosted by Cloudflare workers (formerly Github pages).

## Installation

I have no idea why you'd want to install or run this yourself, but if you do,
(or, more likely, if _I_ do), clone the project, run bundle install, then serve:

```
$ git clone ...
$ bundle install
$ bundle exec jekyll serve
```

Then go to [127.0.0.1:4000](https://127.0.0.1:4000) in a browser.

The Ruby version is pinned in `.ruby-version`; a version manager like rbenv or
mise will pick it up. If you'd rather not install Ruby at all, `bin/serve` and
`bin/build` do the same thing through Docker.
