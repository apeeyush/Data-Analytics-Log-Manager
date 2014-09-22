---
layout: page
title: Updating CODAP
permalink: /documentation/updating_CODAP/index.html
---

Data Analytics Log Manager uses [this](https://github.com/apeeyush/codap/tree/data-analytics) CODAP branch.

**Instructions for updating CODAP code in Log Manager:**

1. Build the CODAP source code using `sc-build`.
2. Copy the `tmp/build/static` folder from CODAP to Rails pubic directory.
3. Copy `public/static/dg/en/...` folder to the `public` directory and rename `...` to `codap`.

