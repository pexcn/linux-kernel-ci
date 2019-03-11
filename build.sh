#!/bin/bash -e

curl -kLs https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.14.105.tar.gz | tar zxf -

cd linux-4.14.105
cp ../config/config-4.14.105 .config
patch -p1 < ../config/0001-prepare-for-tcp-bbr-plus.patch
scripts/config --disable MODULE_SIG
scripts/config --disable DEBUG_INFO
make -j`nproc` deb-pkg
cd ..

mkdir dist
cp linux-headers*.deb dist/
cp linux-image*.deb dist/
cp linux-libc-dev*.deb dist/
