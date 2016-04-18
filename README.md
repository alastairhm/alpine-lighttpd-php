Lighttpd and PHP unning on an Alpine Docker image.

Build using;

docker build -t alpine-lighttpd-php .

Run using;

docker run --name "my-lighttpd-php" -p 8000:80 -v $(pwd):/var/www alpine-lighttpd-php

Works for static & PHP web content.
