# Advanced Encryption Standard (AES) Implementation in Squirrel

The library implements AES-128 encryption in Squirrel. The Squirrel code is based
on the original JavaScript [implementation](https://github.com/ricmoo/aes-js).

**To add this library to your project, add** `#require "AES.lib.nut:0.1.0"`
**to the top of your code.**

The library can be used on both agent and device sides.

## Scope

The AES library supports [AES-128](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
encryption and decryption (might support AES-192 and AES-256 as well, but was never tested with that).
It also supports Cipher Block Chaining mode (CBC) with custom initial vectors (IV).

More modes that were not ported here are available in the original JS
[code base](https://github.com/ricmoo/aes-js/blob/master/index.js).

The library operates exclusively on blobs, e.i. key, iv,
cipher input and output should be of `blob` type.

## AES Class Usage

### constructor(*key*)

The constructor creates an instance of the *EAS* class initialized with a key.

The parameter *key* must be 128 bits (16 bytes), 192 bits (24 bytes) or 256 bits (32 bytes) long.

**Example**

For all the examples we have a function hexStringToBlob(string) that converts a hexadecimal
string to a Squirrel blob:

```
function hexStringToBlob(str) {
    if (str.len() % 2) {
        str = "0" + str;
    }
    local length = str.len() / 2;
    local ret = blob(length);
    for (local idx = 0; idx < length; idx += 1) {
        local part = str.slice(idx * 2, (idx * 2 + 2)).tolower();
        ret.writen(
            (((part[0] <='9' ? (part[0] - '0') : (part[0] - 'a' + 10)) << 4) +
             ((part[1] <='9' ? (part[1] - '0') : (part[1] - 'a' + 10)))),
        'b');
    }
    return ret;
}
```

then usage can be summarized as follows:

### AES
```
local key = hexStringToBlob("babe");
local cipher = hexStringToBlob("c0de");

local aes = AES(key);

local encrypted = aes.encrypt(cipher);
local decrypted = aes.decrypt(encrypted);
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

#### AES
On an imp-001, a 16 byte blob is normally encrypted or decrypted in 6ms.

#### AES-CBC
On an imp-001, a 16 byte blob is normally encrypted or decrypted in 7ms; a 32 byte blob in 13ms (resulting in a 1ms overhead from CBC; which also means you could just always use the CBC version, independent of whether you actually need chaining or not).

# License

The OAuth library is licensed under the [MIT License](LICENSE).