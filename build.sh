#!/usr/bin/env sh

CONFIG=/build/.config
VERSION=$(grep '# Busybox version: ' $CONFIG | cut -d ' ' -f 4)

echo Downloading busybox "$VERSION" ...
cd /build || exit
wget https://www.busybox.net/downloads/busybox-$VERSION.tar.bz2

echo Extracting busybox "$VERSION" ...
tar -xf busybox-"$VERSION".tar.bz2
mv busybox-"$VERSION" busybox

echo Building busybox ...
cd /build/busybox || exit
cp $CONFIG .
make

echo Packaging busybox ...
mkdir /export
cd /export || exit
cp /build/busybox/busybox .
cp /build/busybox/LICENSE .
tar -czvf /busybox.tar.gz *