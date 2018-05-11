#!/bin/bash
# Copyright (C) 2017 PerfectlySoft Inc.
# Author: Jonathan Guthrie <jono@perfect.com>
SWIFT_VERSION=4.1.1
WEBLOC=https://swift.org/builds/swift-$SWIFT_VERSION-release/ubuntu1604/swift-$SWIFT_VERSION-RELEASE/swift-$SWIFT_VERSION-RELEASE-ubuntu16.04.tar.gz
SWIFTNAME=$(basename $WEBLOC)
MYDIR=$(dirname $0)
MYNAME=$(basename $0)
MYSUM=$(md5sum $MYDIR/$MYNAME)

# We want to be self-invoked
if [ "$1" != "--self-invoked" ]; then
    # We want to be sure that installation is ok
    if [ "$1" != "--sure" ]; then
        echo This script will install Swift from: $WEBLOC
        echo If you\'re sure about this, re-run the script like this:
        echo \ \ $0 --sure
        exit 2
      fi
    echo Invoking self...
    exec $MYDIR/$MYNAME --self-invoked
  fi

apt-get -y update

apt-get install -y clang pkg-config libicu-dev libpython2.7 libxml2-dev wget git libssl-dev uuid-dev libsqlite3-dev libpq-dev libmysqlclient-dev libbson-dev libmongoc-dev libcurl4-openssl-dev 

sed -i -e 's/-fabi-version=2 -fno-omit-frame-pointer//g' /usr/lib/x86_64-linux-gnu/pkgconfig/mysqlclient.pc

ln -s /usr/include/libmongoc-1.0 /usr/local/include/libmongoc-1.0

echo Downloading $WEBLOC ...
wget $WEBLOC

echo Installing Swift...
gunzip < $SWIFTNAME | tar -C / -xv --strip-components 1

echo Cleaning up download...
rm $SWIFTNAME

chmod -R 755 /usr/lib/swift/
# Add to avoid the dreaded "error while loading shared libraries: libswiftCore.so: cannot open shared object file: No such file or directory"
touch /etc/ld.so.conf.d/swift.conf
echo "/usr/lib/swift/linux" >> /etc/ld.so.conf.d/swift.conf 
ldconfig

echo All done.
