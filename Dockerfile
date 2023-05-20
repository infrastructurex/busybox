FROM alpine:3.18.0 AS build

ARG ARCH
ENV ARCH=$ARCH
ARG TAG
ENV TAG=$TAG

RUN apk add wget make gcc musl-dev linux-headers
ADD build.sh /build/build.sh
ADD busybox.config /build/.config
RUN /build/build.sh


FROM scratch AS export
COPY --from=build /busybox.tar.gz .
