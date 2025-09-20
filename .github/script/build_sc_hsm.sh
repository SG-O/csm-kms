#!/bin/bash

sudo apt-get update && sudo apt-get install -y build-essential git libpcsclite-dev libusb-1.0-0-dev libssl-dev libcurl4-openssl-dev

git clone https://github.com/CardContact/sc-hsm-embedded.git
cd sc-hsm-embedded
git checkout tags/V2.12

autoreconf -fi
./configure --enable-ram --enable-libcrypto
make


