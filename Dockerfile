FROM ghcr.io/alastairhm/alpine-lighttpd:latest

RUN apk --update add \
    php-common \
    php-iconv \
    php-json \
    php-gd \
    php-curl \
    php-xml \
    php-simplexml \
    php-pgsql \
    php-imap \
    php-cgi \
    fcgi \
    php-pdo \
    php-pdo_pgsql \
    php-soap \
    php-xmlrpc \
    php-posix \
    php-gettext \
    php-ldap \
    php-ctype \
    php-dom && \
    rm -rf /var/cache/apk/*

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
RUN mkdir -p /run/lighttpd/ && \
    chown www-data. /run/lighttpd/

EXPOSE 80
VOLUME /var/www

CMD php-fpm -D && lighttpd -D -f /etc/lighttpd/lighttpd.conf

