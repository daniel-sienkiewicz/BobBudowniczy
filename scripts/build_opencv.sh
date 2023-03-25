#!/bin/bash

set -e

mkdir -p build && cd build
cmake ../opencv
make -j$(nproc)
sudo make install
