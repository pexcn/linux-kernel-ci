#!/bin/bash -e

# download sources
curl -kLs https://cdn.kernel.org/pub/linux/kernel/v${KERNEL_VERSION:0:1}.x/linux-$KERNEL_VERSION.tar.gz | tar zxf -

# prepare config & apply patch
cp config/$KERNEL_VERSION/config-$KERNEL_VERSION linux-$KERNEL_VERSION/.config
find patches/$KERNEL_VERSION -type f -name "*.patch" | sort -n | xargs cat | patch -p1 -d linux-$KERNEL_VERSION

# build kernel
cd linux-$KERNEL_VERSION
make oldconfig
scripts/config --disable MODULE_SIG
scripts/config --disable DEBUG_INFO
sudo -E make -j`nproc` deb-pkg
cd ..

# copy dist files
mkdir dist
cp linux-headers*.deb dist/
cp linux-image*.deb dist/
cp linux-libc-dev*.deb dist/
