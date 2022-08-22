#!/usr/bin/env sh

CONFIG_FILE=/build/.config
VERSION=$(grep '# Busybox version: ' $CONFIG_FILE | cut -d ' ' -f 4)

echo Downloading busybox "$VERSION" ...
cd /build || exit
wget https://www.busybox.net/downloads/busybox-$VERSION.tar.bz2

echo Extracting busybox "$VERSION" ...
tar -xf busybox-"$VERSION".tar.bz2
mv busybox-"$VERSION" busybox

echo Building busybox ...
cd /build/busybox || exit
cp $CONFIG_FILE .
make -j$(nproc) || exit

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

tar -czvf /busybox.tar.gz *
