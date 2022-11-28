#!/bin/sh

cd roc

wget "https://github.com/roc-lang/roc/releases/download/nightly/roc_nightly-linux_x86_64-2022-11-27-468be47.tar.gz"

tar -xzf *.tar.gz
rm *.tar.gz

chmod +x roc

cd ..