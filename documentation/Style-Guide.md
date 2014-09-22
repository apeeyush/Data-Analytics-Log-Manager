---
layout: page
title: Style Guide
permalink: /documentation/style-guide/index.html
---


# Ruby
We will try to use [Github's Ruby Styleguide](https://github.com/styleguide/ruby) for writing Ruby code.

# Documentation
We will try to use [TomDoc](http://tomdoc.org/) for code documentation.

# Javascript
We will try to use [Unobtrusive JavaScript](http://en.wikipedia.org/wiki/Unobtrusive_JavaScript). We will try to prefix classes and ids with js- when touching the DOM with JavaScript.

Example: `<div class="js-open-tab">Blah!!</div>`

This way, we know to look for any JavaScript touching .js-open-tab, which should only be a simple search away. And, now JavaScript and CSS won't share selectors. Since we're separating our content and presentation, we might as well separate our behavior all the way too.

We will try to use camelCase for naming convention in Javascript.