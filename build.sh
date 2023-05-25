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
mkdir /export
cd /export || exit

mkdir sbin
mkdir bin
mkdir -p usr/sbin
mkdir usr/bin
cp /build/busybox/busybox bin

mkdir lib
cp /lib/ld* lib
cp /lib/libc* lib
chroot . /bin/busybox --install -s
rm -r lib

ln -s /sbin/init init

mkdir legal
cat > legal/busybox<< EOF
Source  : $SOURCE
Version : $VERSION
Package : https://github.com/vmify/busybox/releases/download/$TAG/busybox-$ARCH-$TAG.tar.gz
License :

EOF
cat /build/busybox/LICENSE >> legal/busybox
gzip legal/busybox

tar -czvf /busybox.tar.gz *
