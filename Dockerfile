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
