#Alpine-lighttpd-php

[![](http://dockeri.co/image/alastairhm/alpine-lighttpd-php)](https://index.docker.io/u/alastairhm/alpine-lighttpd-php/)

Lighttpd and PHP running on an Alpine Docker image.

Build using;

```bash
docker build -t alpine-lighttpd-php .
```

Run using;

```bash
docker run --name "my-lighttpd-php" --rm -p 8000:80 -v $(pwd):/var/www alastairhm/alpine-lighttpd-php
```

Works for static & PHP web content.
