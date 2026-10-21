# Build php84 from Alpine's own APKBUILD at a newer upstream release than the
# Alpine repos currently ship (8.4.27 fixes CVE-2026-109618 / CVE-2026-109619).
# Drop this stage once Alpine 3.23 publishes php84 >= 8.4.27.
FROM alpine:3.23 AS php-build

ARG PHP_VERSION=8.4.27
# sha256 of php-$PHP_VERSION.tar.xz from https://www.php.net/releases/
ARG PHP_SHA256=dcf93923b0e38e0d5252b25b796520b5a47761a08b3488b6d0b5d1115764d3f0

RUN apk --update add alpine-sdk && \
    adduser -D builder && \
    addgroup builder abuild

USER builder
WORKDIR /home/builder

RUN abuild-keygen -a -n
USER root
RUN cp /home/builder/.abuild/*.rsa.pub /etc/apk/keys/
USER builder

RUN git clone --depth 1 --branch 3.23-stable --filter=blob:none --sparse \
        https://github.com/alpinelinux/aports.git && \
    git -C aports sparse-checkout set community/php84

WORKDIR /home/builder/aports/community/php84

RUN sed -i \
        -e "s/^pkgver=.*/pkgver=$PHP_VERSION/" \
        -e "s/^pkgrel=.*/pkgrel=0\noptions=\"!check\"/" \
        APKBUILD && \
    abuild checksum && \
    echo "$PHP_SHA256  /var/cache/distfiles/php-$PHP_VERSION.tar.xz" | sha256sum -c - && \
    abuild -r

FROM alastairhm/alpine-lighttpd:latest

ARG PHP_VERSION=8.4.27

COPY --from=php-build /home/builder/packages/community /tmp/php-pkgs
COPY --from=php-build /home/builder/.abuild/*.rsa.pub /etc/apk/keys/

RUN apk --update add --repository /tmp/php-pkgs \
    php84-common \
    php84-iconv \
    php84-gd \
    php84-curl \
    php84-xml \
    php84-simplexml \
    php84-pgsql \
    php84-cgi \
    fcgi \
    php84-pdo \
    php84-pdo_pgsql \
    php84-soap \
    php84-posix \
    php84-gettext \
    php84-ldap \
    php84-ctype \
    php84-dom && \
    php-cgi84 -v | grep -q "^PHP $PHP_VERSION " && \
    ! apk info -v | grep '^php84-' | grep -v -- "-$PHP_VERSION-" && \
    rm -rf /tmp/php-pkgs /var/cache/apk/*

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
# The base image no longer creates the www-data user (only the group)
RUN (id www-data >/dev/null 2>&1 || \
        adduser -D -H -h /home/www-data -s /bin/false -u 1000 -G www-data www-data) && \
    mkdir -p /run/lighttpd/ && \
    chown www-data: /run/lighttpd/

EXPOSE 80
VOLUME /var/www

# lighttpd spawns php-cgi itself via mod_fastcgi
CMD ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]

