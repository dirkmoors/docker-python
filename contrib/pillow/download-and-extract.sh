#!/usr/bin/env bash
# Usage: ./download-and-extract.sh something.tar.gz https://example.com/something.tar.gz

archive=$1
url=$2

if [ ! -f $archive.tar.gz ]; then
    curl -o $archive.tar.gz $url
fi

rm -r $archive
tar -xvzf $archive.tar.gz
