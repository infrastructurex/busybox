FROM alpine:3.16.1 AS build

RUN apk add wget make gcc musl-dev linux-headers
ADD build.sh /build/build.sh
ADD busybox.config /build/.config
RUN /build/build.sh


FROM scratch AS export
COPY --from=build /busybox.tar.gz .
