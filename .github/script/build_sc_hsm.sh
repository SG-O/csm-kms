#!/bin/bash

sudo apt-get update && sudo apt-get install -y build-essential git libpcsclite-dev libusb-1.0-0-dev libssl-dev libcurl4-openssl-dev

git clone https://github.com/CardContact/sc-hsm-embedded.git
cd sc-hsm-embedded
git checkout tags/V2.12

autoreconf -fi
./configure --enable-ram --enable-libcrypto
make

COPY ./sc-hsm-embedded/src/pkcs11/.libs/libsc-hsm-pkcs11.so /usr/local/lib/libsc-hsm-pkcs11.so
COPY ./sc-hsm-embedded/src/pkcs11/.libs/libsc-hsm-pkcs11.lai /usr/local/lib/libsc-hsm-pkcs11.la

COPY ./sc-hsm-embedded/src/ramoverhttp/ram-client /usr/local/bin/ram-client
COPY ./sc-hsm-embedded/src/ramoverhttp/ram-client /usr/local/bin/ram-client

COPY ./sc-hsm-embedded/src/sc-hsm/sc-hsm-pkcs11.h /usr/local/include/sc-hsm/sc-hsm-pkcs11.h
RUN mkdir -p /usr/local/etc/udev/rules.d
COPY ./sc-hsm-embedded/etc/udev/rules.d/99-sc_hsm.rules /usr/local/etc/udev/rules.d/99-sc_hsm.rules

