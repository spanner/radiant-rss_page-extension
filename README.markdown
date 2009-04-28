# RSS Page extension

This is a simple thing that adds a few radius tags and makes it very easy to serve RSS feeds. The assumption is that your feed has a root page: might be your blog, might be the home page if you want to serve a site feed. The feed will show everything below that page in descending order of publication date. Some tree-reading is added to the Page class to get all the descendants of a given page. That is all.

The extension adds a 'Rss Feed' page type, which forces the right layout (and therefore content-type) and labels your page nicely in the tree, but doesn't do much else. You can use the RSS tags in any page.

We also have a similar [podcast_page](https://github.com/spanner/radiant-podcast_page-extension/tree) extension. It does exactly the same thing for podcasts, and ought to be made part of this one, but at the moment it requires some updates to the core RSS library so I've kept it separate. This one works as is.

## Requirements

None. Radiant. Content.

## Installation

As usual:

	git submodule add git://github.com/spanner/radiant-rss_page-extension.git vendor/extensions/rss_page

There are no database changes.

## Configuration

If you're not using multi_site, we like to have a site.title and site.url in Radiant::Config.

## Status

New but simple: should just work. No tests yet.

## Usage

	<r:rss [format="0.9|1.0|2.0"] [title="defaults to site title or root page"] [limit="20"] [root="page url. defaults to home page"] />

Feeds should be served as application/rss+xml. Setting page type to `Rss Feed` will do that for you and incidentally create an `RSS` layout if there isn't one already.

## Author & Copyright

* William Ross, for spanner. will at spanner.org
* Copyright 2009 spanner ltd
* Released under the same terms as Rails and/or Radiant

