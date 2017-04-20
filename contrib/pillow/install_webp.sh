#!/usr/bin/env bash
# install webp

archive=libwebp-0.6.0

./download-and-extract.sh $archive https://s3.eu-central-1.amazonaws.com/ekona-platform-dependencies/$archive.tar.gz

pushd $archive

./configure --prefix=/usr --enable-libwebpmux --enable-libwebpdemux && make -j4 && make -j4 install

popd
