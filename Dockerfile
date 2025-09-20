FROM debian:bookworm-20250428-slim AS builder

ENV OPENSSL_DIR=/usr/local/openssl

RUN apt-get update && apt-get install -y \
    build-essential binutils make csh g++ sed gawk autoconf automake autotools-dev libtool \
    git \
    libpcsclite-dev \
    libusb-1.0-0-dev \
    libssl-dev \
    libcurl4-openssl-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /root

RUN git clone https://github.com/CardContact/sc-hsm-embedded.git
RUN git clone https://github.com/Cosmian/kms.git
WORKDIR /root/kms

ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then export ARCHITECTURE=x86_64; elif [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then export ARCHITECTURE=arm; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then export ARCHITECTURE=arm64; else export ARCHITECTURE=x86_64; fi \
    && bash /root/kms/.github/reusable_scripts/get_openssl_binaries.sh

WORKDIR /root/sc-hsm-embedded
RUN git checkout tags/V2.12

RUN autoreconf -fi
RUN ./configure --enable-ram
RUN make


FROM ghcr.io/cosmian/kms:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    pcscd \
    libccid \
    libpcsclite-dev \
    libssl-dev \
    libusb-1.0-0-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


COPY --from=builder /root/sc-hsm-embedded/src/pkcs11/.libs/libsc-hsm-pkcs11.so /usr/local/lib/libsc-hsm-pkcs11.so
COPY --from=builder /root/sc-hsm-embedded/src/pkcs11/.libs/libsc-hsm-pkcs11.lai /usr/local/lib/libsc-hsm-pkcs11.la

COPY --from=builder /root/sc-hsm-embedded/src/ramoverhttp/ram-client /usr/local/bin/ram-client
COPY --from=builder /root/sc-hsm-embedded/src/ramoverhttp/ram-client /usr/local/bin/ram-client

COPY --from=builder /root/sc-hsm-embedded/src/sc-hsm/sc-hsm-pkcs11.h /usr/local/include/sc-hsm/sc-hsm-pkcs11.h
RUN mkdir -p /usr/local/etc/udev/rules.d
COPY --from=builder /root/sc-hsm-embedded/etc/udev/rules.d/99-sc_hsm.rules /usr/local/etc/udev/rules.d/99-sc_hsm.rules
