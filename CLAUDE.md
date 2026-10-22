# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Docker image (`alastairhm/alpine-lighttpd-php`) that serves static and PHP content with lighttpd + PHP on Alpine. There is no application code; the repo is just the `Dockerfile`, `lighttpd.conf`, and a `phpinfo()` `html/index.php` for smoke testing.

## Commands

Tasks are defined in `Taskfile.yml` (https://taskfile.dev): `task build`, `task push`, `task test`.

Smoke test: open http://localhost:8000 after `task test`; `html/index.php` renders `phpinfo()` and should report the expected PHP version. Mount `html/` (or another directory of public files only), not the repo root, since anything under the mount is served.

There is no lint or unit test suite.

## Architecture

- **Layered on a sibling image**: `FROM alastairhm/alpine-lighttpd:latest`, not plain Alpine. The Alpine version, lighttpd itself, the `lighttpd` user that lighttpd and the `php-cgi` workers run as, and the `mod_fastcgi.conf` that `lighttpd.conf` includes all come from that base image. The base no longer creates a `www-data` user, so don't reintroduce it. Bumping the Alpine version (as most past commits do) happens upstream in that image; this repo then gets rebuilt and the CHANGELOG/tag updated.
- **Runtime**: `CMD` runs lighttpd in the foreground. There is no php-fpm: `mod_fastcgi.conf` makes lighttpd spawn `/usr/bin/php-cgi` workers itself. `lighttpd.conf` stops `.php` files being served as static files, adds `index.php` to the index files, and denies dotfiles via `mod_access`. Because it replaces the base image's config, anything the base config set up (like that deny rule) must be repeated here.
- **Temporary PHP build stage**: the `php-build` stage compiles `php84` from Alpine's 3.23 APKBUILD at a newer upstream version than Alpine ships (for the php2shell CVEs, issue #5), and the final stage installs those `.apk`s from a local repo. A full build takes ~20 minutes (the APKBUILD compiles PHP twice). Remove the stage and go back to plain `apk add php84-*` once Alpine 3.23 ships `php84` >= 8.4.27.
- **Content**: document root is `/var/www` (a `VOLUME`), meant to be bind-mounted.
- **PHP extensions**: installed via `apk` as explicit `php84-*` packages in the `Dockerfile`. Add new ones there. There is no `php84-imap` in Alpine.

## CI / release

Every push to `master` builds and publishes `:latest` to two places:
- GitHub Actions (`.github/workflows/deploy.yml`) → `ghcr.io/alastairhm/alpine-lighttpd-php:latest`
- Woodpecker (`.woodpecker/docker.yml`, also on manual/cron) → Docker Hub `alastairhm/alpine-lighttpd-php:latest`

Releases are git tags named after the Alpine version (e.g. `3.23.0`). Record changes in `CHANGELOG.md` (Keep a Changelog format, dates `YYYY-MM-DD`, list new items under `[Unreleased]`).
