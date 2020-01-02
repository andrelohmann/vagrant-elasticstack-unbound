# Fetch the ubuntu bionic image
FROM ubuntu:bionic

ENV BUILDDIR /build

WORKDIR ${BUILDDIR}

RUN apt update -yqq; \
    apt install -yqq wget xz-utils gpg

ADD build_unbound.sh $BUILDDIR

RUN ./build_unbound.sh
