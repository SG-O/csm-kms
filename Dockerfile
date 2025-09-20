FROM ghcr.io/sg-o/kms:develop

# Install required packages
RUN apt-get update && apt-get install -y \
    pcscd \
    libccid \
    libpcsclite-dev \
    libssl-dev \
    libusb-1.0-0-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


COPY ./lib/x86_64/libsc-hsm-pkcs11.so /usr/local/lib/libsc-hsm-pkcs11.so
COPY ./lib/x86_64/libsc-hsm-pkcs11.la /usr/local/lib/libsc-hsm-pkcs11.la

COPY ./lib/sc-hsm-pkcs11.h /usr/local/include/sc-hsm/sc-hsm-pkcs11.h
RUN mkdir -p /usr/local/etc/udev/rules.d
COPY ./lib/rules.d/99-sc_hsm.rules /usr/local/etc/udev/rules.d/99-sc_hsm.rules
