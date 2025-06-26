# csm-kms

This custom build of of Cosmian KMS intends to add smart card support by installing:

- `pcscd`, `libccid`, `libpcsclite-dev`, `opensc`, `opensc-pkcs11`
- A symbolic link: `/lib/libcs_pkcs11_R3.so -> /usr/lib/opensc-pkcs11.so`
