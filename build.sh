#!/bin/bash -e

KERNEL_LEVEL="$(echo $KERNEL_VERSION | cut -d '.' -f 1-2).x"

# download sources
curl -sSL https://cdn.kernel.org/pub/linux/kernel/v${KERNEL_VERSION:0:1}.x/linux-$KERNEL_VERSION.tar.gz | tar -zxf -

# prepare config & apply patch
cp config/config-$KERNEL_LEVEL linux-$KERNEL_VERSION/.config
if [ -d "patches/$KERNEL_LEVEL" ]; then
  find patches/$KERNEL_LEVEL -type f -name "*.patch" | sort -n | xargs cat | patch -p1 -d linux-$KERNEL_VERSION
fi

# build kernel
cd linux-$KERNEL_VERSION
make oldconfig
scripts/config --disable MODULE_SIG
scripts/config --disable DEBUG_INFO
make -j$(nproc) deb-pkg
cd ..
