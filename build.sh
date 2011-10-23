#!/bin/sh -x

BUILD=/home/robc/src/workrave-build/
rm -rf "$BUILD" > /dev/null 2>&1
mkdir -p "$BUILD"

SOURCE="$1"
VERSION=`echo $SOURCE | sed -e 's/.*-\(.*\).tar.gz/\1/'`

echo "Preparing build environment"

tar xzfC "$SOURCE" "$BUILD"  || exit 1
cp "$SOURCE" "$BUILD/workrave_$VERSION.orig.tar.gz" || exit 1
cp -r ./debian "$BUILD/workrave-$VERSION/debian" || exit 1

(   rm -rf "$BUILD/local" > /dev/null 2>&1 ;
    mkdir -p "$BUILD/local" && 
    ln "$SOURCE" "$BUILD/local/workrave_$VERSION.orig.tar.gz" && 
    cp -a "$BUILD/workrave-$VERSION" "$BUILD/local" && 
    cd "$BUILD/local/workrave-$VERSION" &&
    sudo ARCH=amd64 pdebuild --debbuildopts "-j12 -sa"
    ) > local.log 2>&1
