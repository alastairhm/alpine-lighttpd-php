# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

Dates in this file are in format of YYYY-MM-DD (2019-12-13 means 13th of December 2019).

## [Unreleased]

* Link the [php2shell blog post](https://blog.0x32.co.uk/posts/php2shell-alpine-lighttpd-php/) from the README

## [[3.23.5]](https://github.com/alastairhm/alpine-lighttpd-php/releases/tag/3.23.5) - 2026-10-22

* Woodpecker CI pipeline testing

### Security

* Build PHP 8.4.27 from Alpine's `php84` APKBUILD to fix php2shell (CVE-2026-109618, CVE-2026-109619), until Alpine 3.23 ships a patched package ([#5](https://github.com/alastairhm/alpine-lighttpd-php/issues/5))

### Fixed

* GitHub Actions no longer pushes pull request builds to `ghcr.io/...:latest`; PRs now only build, tagged `pr-<number>`
* Removed dead `php-fpm -D &&` from the container `CMD`: the `php-fpm` package
  was never installed, so the container crashed on every start before
  lighttpd even launched. PHP is served via lighttpd's own `mod_fastcgi`
  spawning `php-cgi` (see `mod_fastcgi.conf`), so `php-fpm` was unnecessary.
* Switched `chown`/`server.username`/`server.groupname` from `www-data` to
  `lighttpd`, matching the base `alpine-lighttpd` image's package-provided
  user (the base image no longer creates a `www-data` account)
* Restored the `mod_access` dotfile/dot-directory deny rule in
  `lighttpd.conf`, which this image's own conf file was silently dropping
  from the base image
* Use `COPY` instead of `ADD` for a local file
* Moved `index.php` into `html/` and updated README/Taskfile volume-mount
  examples to avoid serving the whole mounted directory verbatim

### Removed

* `php-imap`: Alpine has no PHP 8.4 package, and the PHP 8.3 extension it installed was never loaded
* `php-json`: built into PHP 8.4

## [[3.23.0]](https://github.com/alastairhm/alpine-lighttpd-php/releases/tag/3.23.0) - 2025-12-07

* Built with 3.23 Alpine Base

## [[3.22.0]](https://github.com/alastairhm/alpine-lighttpd-php/releases/tag/3.22.0) - 2025-10-12

* Built with 3.22 Alpine Base
* Update Github action versions

## [[3.21.0]](https://github.com/alastairhm/alpine-lighttpd-php/releases/tag/3.21.0) - 2024-12-22

* Taskfile
* Build with 3.21 Alpine base, lighttpd/1.4.73, PHP Version 8.3.15
* Build with 3.19 Alpine base, lighttpd/1.4.73, PHP Version 8.2.16
* Build with 3.17 Alpine base, lighttpd/1.4.67, PHP Version 8.1.17
* Build with 3.15 Alpine base, lighttpd/1.4.64, PHP Version 7.4.28

### Added

* Added GitHub action to build and push package

## [[3.14.1]](https://github.com/alastairhm/alpine-lighttpd-php/releases/tag/3.14.1) - 2021-08-12

### Changed

* Install SimpleXML module [wdssmq](https://github.com/wdssmq)

## [[3.14]](https://github.com/alastairhm/alpine-lighttpd-php/releases/tag/3.14) - 2021-07-22

### Changed

* Build with 3.14 Alpine base image, PHP 7.4.21

## [[3.13]](https://github.com/alastairhm/alpine-lighttpd-php/releases/tag/3.13) - 2021-05-14

### Changed

* Build with 3.13 Alpine base image, PHP 7.4.19

## [[3.12]](https://github.com/alastairhm/alpine-lighttpd-php/releases/tag/3.12) - 2020-12-14

### Changed

* Build with 3.12 Alpine base image
