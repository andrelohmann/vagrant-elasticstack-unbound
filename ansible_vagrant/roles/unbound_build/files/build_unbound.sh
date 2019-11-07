#!/bin/bash

# create a working directory
mkdir base_source
cd base_source

# Fetch the source package of unbound 1.9.0 from lunchpad
# https://launchpad.net/ubuntu/xenial/+source/unbound
wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/unbound/1.9.0-2ubuntu2/unbound_1.9.0.orig.tar.gz
wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/unbound/1.9.0-2ubuntu2/unbound_1.9.0-2ubuntu2.debian.tar.xz
wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/unbound/1.9.0-2ubuntu2/unbound_1.9.0-2ubuntu2.dsc

# unback debian.tar.xz to debian folder
tar -xvf unbound_1.9.0-2ubuntu2.debian.tar.xz

# replace dependency package version numbers in debian/control
sed "s/ debhelper .*/ debhelper,/g" -i debian/control
sed "s/ dpkg-dev .*/ dpkg-dev,/g" -i debian/control
sed "s/ libbsd-dev .*/ libbsd-dev [!linux-any],/g" -i debian/control
sed "s/ python-dev:any .*/ python-dev:any \<\!pkg.unbound.libonly\>,/g" -i debian/control
sed "s/ libpython-dev .*/ libpython-dev \<\!pkg.unbound.libonly\>,/g" -i debian/control
sed "s/ lsb-base .*/ lsb-base,/g" -i debian/control

# remove patches
rm debian/patches/*
touch debian/patches/series

# add following to top of debian/changelog
cat << EOF > tmp_changelog
unbound (1.9.4-al1) xenial; urgency=medium

  * build by Andre Lohmann.

 -- Andre Lohmann <lohmann.andre@gmail.com>  $(LC_ALL=en_US date +"%a, %d %b %Y %T %z")

EOF
cat tmp_changelog debian/changelog > changelog
mv changelog debian/changelog
rm tmp_changelog

#######
# repackage
tar -cJf unbound_1.9.4-al1.debian.tar.xz debian/

# fetch the latest sources from unbound 1.9.4
wget https://github.com/NLnetLabs/unbound/archive/release-1.9.4.tar.gz
mv release-1.9.4.tar.gz unbound_1.9.4.orig.tar.gz

# fetch checksums and sizes
SHA1_ORIG=$(sha1sum unbound_1.9.4.orig.tar.gz | cut -d " " -f 1)
SHA256_ORIG=$(sha256sum unbound_1.9.4.orig.tar.gz | cut -d " " -f 1)
MD5_ORIG=$(md5sum unbound_1.9.4.orig.tar.gz | cut -d " " -f 1)
SIZE_ORIG=$(stat --printf="%s" unbound_1.9.4.orig.tar.gz)
SHA1_DEB=$(sha1sum unbound_1.9.4-al1.debian.tar.xz | cut -d " " -f 1)
SHA256_DEB=$(sha256sum unbound_1.9.4-al1.debian.tar.xz | cut -d " " -f 1)
MD5_DEB=$(md5sum unbound_1.9.4-al1.debian.tar.xz | cut -d " " -f 1)
SIZE_DEB=$(stat --printf="%s" unbound_1.9.4-al1.debian.tar.xz)

# remove gpg signature and rename unbound_1.9.0-2ubuntu2.dsc
cat unbound_1.9.0-2ubuntu2.dsc | gpg >unbound_1.9.0-2ubuntu2.dsc.tmp || true
rm unbound_1.9.0-2ubuntu2.dsc
mv unbound_1.9.0-2ubuntu2.dsc.tmp unbound_1.9.0-2ubuntu2.dsc
mv unbound_1.9.0-2ubuntu2.dsc unbound_1.9.4-al1.dsc

# read original Maintainer
ORIG_MAINTAINER=$(cat unbound_1.9.4-al1.dsc | grep Original-Maintainer | cut -d ":" -f 2 | xargs)

# change Version
sed "s/Version: 1.9.0-2ubuntu2/Version: 1.9.4-al1/g" -i unbound_1.9.4-al1.dsc
# remove package version numbers, as they might collide with lower versions available on xenial
sed "s/Build-Depends: .*/Build-Depends: autoconf, autotools-dev, bison, debhelper, dh-apparmor \<\!pkg.unbound.libonly\>, dh-autoreconf, dh-python \<\!pkg.unbound.libonly\>, dpkg-dev, flex, libbsd-dev [!linux-any], libevent-dev, libexpat1-dev, libfstrm-dev \<\!pkg.unbound.libonly\>, libprotobuf-c-dev \<\!pkg.unbound.libonly\>, libssl-dev \<\!pkg.unbound.libonly\>, libsystemd-dev \<\!pkg.unbound.libonly\>, libtool, nettle-dev, pkg-config, protobuf-c-compiler \<\!pkg.unbound.libonly\>, python-dev:any \<\!pkg.unbound.libonly\>, libpython-dev \<\!pkg.unbound.libonly\>, python3-dev:any \<\!pkg.unbound.libonly\>, libpython3-dev \<\!pkg.unbound.libonly\>, swig \<\!pkg.unbound.libonly\>/g" -i unbound_1.9.4-al1.dsc

# remove wrong checksums + trailing newlines
sed '/Checksums-Sha1*/,/Original-Maintainer*/d' -i unbound_1.9.4-al1.dsc
sed -e :a -e '/^\n*$/{$d;N;};/\n$/ba' -i unbound_1.9.4-al1.dsc

# add new checksums
cat << EOF >> unbound_1.9.4-al1.dsc
Checksums-Sha1:
 $SHA1_ORIG $SIZE_ORIG unbound_1.9.4.orig.tar.gz
 $SHA1_DEB $SIZE_DEB unbound_1.9.4-al1.debian.tar.xz
Checksums-Sha256:
 $SHA256_ORIG $SIZE_ORIG unbound_1.9.4.orig.tar.gz
 $SHA256_DEB $SIZE_DEB unbound_1.9.4-al1.debian.tar.xz
Files:
 $MD5_ORIG $SIZE_ORIG unbound_1.9.4.orig.tar.gz
 $MD5_DEB $SIZE_DEB unbound_1.9.4-al1.debian.tar.xz
Original-Maintainer: $ORIG_MAINTAINER
EOF

# build
cd ..
mkdir build_source
cd build_source
cp ../base_source/unbound_1.9.4.orig.tar.gz .
cp ../base_source/unbound_1.9.4-al1.debian.tar.xz .
cp ../base_source/unbound_1.9.4-al1.dsc .

apt install -yqq autoconf autotools-dev bison debhelper dh-apparmor dh-autoreconf dh-python dpkg-dev flex libbsd-dev libevent-dev libexpat1-dev libfstrm-dev libprotobuf-c-dev libssl-dev libsystemd-dev libtool nettle-dev pkg-config protobuf-c-compiler python-dev libpython-dev python3-dev libpython3-dev swig adduser dns-root-data lsb-base openssl dh-systemd

dpkg-source -x unbound_1.9.4-al1.dsc
cd unbound-1.9.4
#chmod a-x debian/*.install
#chmod a-x debian/*.dirs
#chmod a-x debian/*.docs
#chmod a-x debian/*.maintscript
#chmod a-x debian/*.symbols
#chmod a-x debian/*.conf
#chmod a-x debian/*.init
#chmod a-x debian/*.postinst
#chmod a-x debian/*.postrm
#chmod a-x debian/*.prerm
#chmod a-x debian/*.service
dpkg-buildpackage -us -uc -b

cd ..

tar -cJf unbound_1.9.4-packages.tar.xz *.deb
