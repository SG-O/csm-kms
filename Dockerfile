FROM ghcr.io/cosmian/kms:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    pcscd \
    libccid \
    libpcsclite-dev \
    opensc \
    opensc-pkcs11 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Create a symlink to the opensc-pkcs11 library
RUN ln -s /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so /lib/libcs_pkcs11_R3.so
