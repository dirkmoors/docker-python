#!/usr/bin/env bash
# install libimagequant

archive=libimagequant-2.8.2

./download-and-extract.sh $archive https://s3.eu-central-1.amazonaws.com/ekona-platform-dependencies/$archive.tar.gz

pushd $archive

make shared
cp libimagequant.so* /usr/lib/
cp libimagequant.h /usr/include/

popd
