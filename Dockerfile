FROM python:3.5.2-alpine

RUN set -x \
    && BASE_PKGS='su-exec bash' \
    && apk add --no-cache make ${BASE_PKGS}

COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
