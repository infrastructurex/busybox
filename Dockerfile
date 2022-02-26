FROM alpine:3.15.0 AS build

RUN apk add wget make gcc musl-dev linux-headers
ADD build.sh /build/build.sh
ADD busybox.config /build/.config
RUN sh -c /build/build.sh


FROM scratch AS export
COPY --from=build /busybox.tar.gz .