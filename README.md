# Alpine-lighttpd-php

[![](http://dockeri.co/image/alastairhm/alpine-lighttpd-php)](https://index.docker.io/u/alastairhm/alpine-lighttpd-php/)

[![Deploy Docker](https://github.com/alastairhm/alpine-lighttpd-php/actions/workflows/deploy.yml/badge.svg)](https://github.com/alastairhm/alpine-lighttpd-php/actions/workflows/deploy.yml)

Lighttpd and PHP running on an Alpine Docker image.

> [!WARNING]
> **php2shell (CVE-2026-109618 / CVE-2026-109619).** Images built before this fix ship PHP 8.4.16. That version is vulnerable to two critical, unauthenticated remote code execution flaws, fixed upstream in PHP 8.4.27. See [issue #5](https://github.com/alastairhm/alpine-lighttpd-php/issues/5) and the write-up [php2shell and alpine-lighttpd-php](https://blog.0x32.co.uk/posts/php2shell-alpine-lighttpd-php/).
>
> Alpine 3.23 has not yet published a patched `php84` package. Until it does, the `Dockerfile` builds `php84` 8.4.27 from Alpine's own APKBUILD, so the first build takes much longer than usual. Once a patched image is published, pull it again:
>
> ```bash
> docker pull alastairhm/alpine-lighttpd-php:latest
> ```
>
> If you can't update yet, setting `session.upload_progress.enabled = 0` in `/etc/php84/conf.d/` reduces the risk but does not remove it.
>
> This build also drops `php-imap`. Alpine has no PHP 8.4 IMAP package, and the PHP 8.3 extension it used to install was never loaded.

Build using;

```bash
docker build -t alpine-lighttpd-php .
```

Run from Docker Hub using;

```bash
docker run --name "my-lighttpd-php" --rm -p 8000:80 -v $(pwd)/html:/var/www alastairhm/alpine-lighttpd-php
```

Or from GitHub packages using;

```bash
docker run --name "my-lighttpd-php" --rm -p 8000:80 -v $(pwd)/html:/var/www ghcr.io/alastairhm/alpine-lighttpd-php
```

Works for static & PHP web content. Mount a directory that contains only the files you
intend to serve — anything under the mounted path is reachable over HTTP, so avoid
mounting a repo root or other directory containing non-public files (e.g. `.git`,
`Dockerfile`, secrets).

```text
          _    _ __  __ 
    /\   | |  | |  \/  | Email   : alastair@montgomery.me.uk
   /  \  | |__| | \  / | Web     : https://blog.0x32.co.uk/
  / /\ \ |  __  | |\/| | Twitter : @alastair_hm
 / ____ \| |  | | |  | |
/_/    \_\_|  |_|_|  |_| (c) 2021
```
