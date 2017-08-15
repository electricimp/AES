# aes-squirrel
AES in Squirrel.

## Scope
- supports AES-128 encryption and decryption (might support AES-192 and AES-256 as well, but was never tested with that)
- supports Cipher Block Chaining mode (CBC) – more modes available in the original JS code base (https://github.com/ricmoo/aes-js/blob/master/index.js)
- CBC supports custom IVs
- operates exclusively on blobs (key, iv, cipher input and output)

## Usage
Assume we have a function hexStringToBlob(string) that converts a hexadecimal string to a Squirrel blob (as exemplified at https://forums.electricimp.com/discussion/1389/efficient-hexadecimal-string-to-binary-blob-function), then usage can be summarized as follows:

### AES
```
key <- hexStringToBlob("11111111111111111111111111111111")
cipher <- hexStringToBlob("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

aes <- AES(key)

encrypted <- aes.encrypt(cipher)
decrypted <- aes.decrypt(encrypted)
// decrypted == cipher
```

### AES-CBC
```
key <- hexStringToBlob("11111111111111111111111111111111")
cipher <- hexStringToBlob("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
iv <- hexStringToBlob("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb")

cbc <- AES_CBC(key, iv)

encrypted <- cbc.encrypt(cipher)
decrypted <- cbc.decrypt(encrypted)
// decrypted == cipher
```

## Performance
Fast.

### AES
On an imp-001, a 16 byte blob is normally encrypted or decrypted in 6ms.

### AES-CBC
On an imp-001, a 16 byte blob is normally encrypted or decrypted in 7ms; a 32 byte blob in 13ms (resulting in a 1ms overhead from CBC; which also means you could just always use the CBC version, independent of whether you actually need chaining or not).
