###################################################################################
# Based on alpine
#
# To build, do:
#   $ docker build -t crea/util .
#
###################################################################################

FROM alpine:3.4
MAINTAINER bitard [dot] michael [at] gmail [dot] com

RUN apk add --update bash && rm -rf /var/cache/apk/*

## YOUTUBE-DL

RUN set -x \
 && apk add --no-cache ca-certificates curl ffmpeg python \
    # Install youtube-dl
    # https://github.com/rg3/youtube-dl
 && curl -Lo /usr/local/bin/youtube-dl https://yt-dl.org/downloads/latest/youtube-dl \
 && chmod a+rx /usr/local/bin/youtube-dl \
    # Clean-up
 && apk del curl \
    # Create directory to hold downloads.
 && mkdir /downloads \
 && chmod a+rw /downloads \
    # Basic check it works.
 && youtube-dl --version

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt


## PDFTK

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@community http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache pdftk@community libgcj@edge

## GHOSTSCRIPT & IMAGEMAGICK
RUN apk add --no-cache inotify-tools imagemagick ghostscript

## QPDF
RUN apk add --no-cache qpdf


WORKDIR /downloads

VOLUME /downloads

CMD bash
