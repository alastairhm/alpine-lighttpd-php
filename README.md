[![](http://dockeri.co/image/alastairhm/alpine-lighttpd-php)](https://index.docker.io/u/alastairhm/alpine-lighttpd-php/)

Lighttpd and PHP unning on an Alpine Docker image.

Build using;

docker build -t alpine-lighttpd-php .

Run using;

docker run --name "my-lighttpd-php" -p 8000:80 -v $(pwd):/var/www alastairhm/alpine-lighttpd-php

Works for static & PHP web content.
