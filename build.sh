#!/usr/bin/env sh

CONFIG_FILE=/build/.config
VERSION=$(grep '# Busybox version: ' $CONFIG_FILE | cut -d ' ' -f 4)
SOURCE=https://www.busybox.net/downloads/busybox-$VERSION.tar.bz2

echo Downloading busybox "$VERSION" ...
cd /build || exit
wget "$SOURCE"

echo Extracting busybox "$VERSION" ...
tar -xf busybox-"$VERSION".tar.bz2
mv busybox-"$VERSION" busybox

echo Building busybox ...
cd /build/busybox || exit
cp $CONFIG_FILE .
make "-j$(nproc)" || exit

echo Packaging busybox ...
mkdir -p /export/busybox
cd /export/busybox || exit

mkdir sbin
mkdir bin
mkdir -p usr/sbin
mkdir usr/bin
cp /build/busybox/busybox bin
chroot . /bin/busybox --install -s
ln -s /sbin/init init

cd ..
cp /build/busybox/LICENSE .
echo "Source  : $SOURCE" > /export/SOURCE
echo "Version : $VERSION" >> /export/SOURCE
echo "Package : https://github.com/vmify/busybox/releases/download/$TAG/busybox-$ARCH-$TAG.tar.gz" >> /export/SOURCE

tar -czvf /busybox.tar.gz *
