# Fetch the ubuntu xenial image
FROM ubuntu:xenial

ENV BUILDDIR /build

WORKDIR ${BUILDDIR}

RUN apt update -yqq; \
    apt install -yqq wget xz-utils

ADD build_unbound.sh $BUILDDIR

RUN ./build_unbound.sh
