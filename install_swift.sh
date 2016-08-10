#!/bin/bash
# Copyright (C) 2016 PerfectlySoft Inc.
# Author: Shao Miller <swiftcode@synthetel.com>

WEBLOC=https://swift.org/builds/development/ubuntu1510/swift-DEVELOPMENT-SNAPSHOT-2016-08-04-a/swift-DEVELOPMENT-SNAPSHOT-2016-08-04-a-ubuntu15.10.tar.gz
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


echo Entering directory $MYDIR ...
cd $MYDIR

echo Updating git repository...
git pull origin master || echo Git repository unavailable.

# We want to run the latest version
NEWSUM=$(md5sum $MYDIR/$MYNAME)
if [ "$MYSUM" != "$NEWSUM" ]; then
    echo Invoking latest version of script...
    exec $MYDIR/$MYNAME --self-invoked
  fi

echo Downloading $WEBLOC ...
wget $WEBLOC

echo Installing Swift...
gunzip < $SWIFTNAME | tar -C / -xv --strip-components 1

echo Cleaning up download...
rm $SWIFTNAME

echo All done.
