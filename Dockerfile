FROM alpine:3.15.0 AS build

ARG BUSYBOX_VERSION
ENV VERSION=$BUSYBOX_VERSION

RUN apk add wget make gcc musl-dev linux-headers
ADD build.sh /build/build.sh
RUN chmod +x /build/build.sh && sh -c /build/build.sh


FROM scratch AS export
COPY --from=build /export/busybox .
COPY --from=build /export/LICENSE .