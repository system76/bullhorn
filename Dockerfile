FROM elixir:1.14.1-alpine as build

# Install deps
RUN set -xe; \
    apk add --update  --no-cache --virtual .build-deps \
        ca-certificates \
        g++ \
        gcc \
        git \
        make \
        musl-dev \
        tzdata;

# Use the standard /usr/local/src destination
RUN mkdir -p /usr/local/src/bullhorn

COPY . /usr/local/src/bullhorn/

# ARG is available during the build and not in the final container
# https://vsupalov.com/docker-arg-vs-env/
ARG MIX_ENV=prod
ARG APP_NAME=bullhorn

# Use `set -xe;` to enable debugging and exit on error
# More verbose but that is often beneficial for builds
RUN set -xe; \
    cd /usr/local/src/bullhorn/; \
    mix local.hex --force; \
    mix local.rebar --force; \
    mix deps.get; \
    mix deps.compile --all; \
    mix release

FROM alpine:3.16.2 as release

RUN set -xe; \
    apk add --update  --no-cache --virtual .runtime-deps \
        ca-certificates \
        libmcrypt \
        ncurses-libs \
        tzdata;

# Create a `bullhorn` group & user
# I've been told before it's generally a good practice to reserve ids < 1000 for the system
RUN set -xe; \
    addgroup -g 1000 -S bullhorn; \
    adduser -u 1000 -S -h /bullhorn -s /bin/sh -G bullhorn bullhorn;

ARG APP_NAME=bullhorn

# Copy the release artifact and set `bullhorn` ownership
COPY --chown=bullhorn:bullhorn --from=build /usr/local/src/bullhorn/_build/prod/rel/${APP_NAME} /bullhorn

# These are fed in from the build script
ARG VCS_REF
ARG BUILD_DATE
ARG VERSION

# `Maintainer` has been deprecated in favor of Labels / Metadata
# https://docs.docker.com/engine/reference/builder/#maintainer-deprecated
LABEL \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.description="bullhorn" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.source="https://github.com/system76/bullhorn" \
    org.opencontainers.image.title="bullhorn" \
    org.opencontainers.image.vendor="system76" \
    org.opencontainers.image.version="${VERSION}"

ENV \
    PATH="/usr/local/bin:$PATH" \
    VERSION="${VERSION}" \
    MIX_APP="bullhorn" \
    MIX_ENV="prod" \
    SHELL="/bin/bash"

# Drop down to our unprivileged `bullhorn` user
USER bullhorn

WORKDIR /bullhorn

EXPOSE 8080

ENTRYPOINT ["/bullhorn/bin/bullhorn"]

CMD ["start"]
