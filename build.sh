#!/bin/bash -e

> /etc/apt/sources.list
echo "deb http://cdn-fastly.deb.debian.org/debian stretch main contrib non-free" >> /etc/apt/sources.list
echo "deb http://cdn-fastly.deb.debian.org/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb http://cdn-fastly.deb.debian.org/debian stretch-backports main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://cdn-fastly.deb.debian.org/debian stretch main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://cdn-fastly.deb.debian.org/debian stretch-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://cdn-fastly.deb.debian.org/debian stretch-backports main contrib non-free" >> /etc/apt/sources.list
echo "deb http://cdn-fastly.deb.debian.org/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://cdn-fastly.deb.debian.org/debian-security stretch/updates main contrib non-free" >> /etc/apt/sources.list

apt-get update
apt-get -t stretch-backports install -y build-essential libncurses5-dev lsb-release quilt kernel-wedge
apt-get build-dep linux

curl -kLs https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.14.105.tar.gz | tar zxf -

cd linux-4.14.105
curl -kLs https://raw.githubusercontent.com/pexcn/share/gh-pages/bbr-plus/config-4.14.105 -o .config
curl -kLs https://raw.githubusercontent.com/pexcn/share/gh-pages/bbr-plus/0001-patch-for-bbr-plus.patch | patch -p1
scripts/config --disable MODULE_SIG
scripts/config --disable DEBUG_INFO
make deb-pkg
cd ..

mkdir deb
cp linux-headers*.deb deb/
cp linux-image*.deb deb/
cp linux-libc-dev*.deb deb/
