#!/usr/bin/env sh

echo Downloading busybox "$VERSION" ...
cd /build || exit
wget https://www.busybox.net/downloads/busybox-$VERSION.tar.bz2

echo Extracting busybox "$VERSION" ...
tar -xf busybox-"$VERSION".tar.bz2
mv busybox-"$VERSION" busybox

echo Building busybox ...
cd /build/busybox || exit
make defconfig
sed -i '/# CONFIG_STATIC is not set/c\CONFIG_STATIC=y' .config
make

echo Packaging busybox ...
mkdir /export
cd /export || exit
cp /build/busybox/busybox .
cp /build/busybox/LICENSE .