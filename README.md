# Advanced Encryption Standard (AES) Implementation in Squirrel

The library implements AES-128 encryption in Squirrel. The Squirrel code is based
on the original JavaScript [implementation](https://github.com/ricmoo/aes-js).

**To add this library to your project, add** `#require "AES.lib.nut:1.0.0"`
**to the top of your code.**

The library can be used on both agent and device sides.

## Scope

The AES library supports [AES-128](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
encryption and decryption (might support AES-192 and AES-256 as well, but was never tested with that).

It also supports Cipher Block Chaining mode (CBC) with custom initial vectors (IV).

More modes that were not ported here are available in the original JS
[code base](https://github.com/ricmoo/aes-js/blob/master/index.js).

**NOTE:** The library operates exclusively on blobs, e.i. key, iv,
cipher input and output should be of `blob` type. For developers' convenience a helper function
that converts a hexadecimal string into a blob value
is provided by the library `AES.hexStringToBlob(string)`.

## AES Class Usage

### constructor(*key*)

The constructor creates an instance of the *AES* class initialized with a key.

The parameter *key* must be 128 bits (16 bytes), 192 bits (24 bytes) or 256 bits (32 bytes) long.

**Example**

The following code creates an AES object instance:

```squirrel
local aes = AES(keyBlob);

// aes object usage ...
```

### encrypt(*valueBlob*)

Encrypts the specified value with the key that the AES instance is initialized with.
`valueBlob` must be 16 byte long `blob`. The function returns a blob with result of
the encryption process.

For string-to-blob conversions please use [hexStringToBlob](#hexstringtoblobstr).

**Example**

The following code encrypts the value and stores it in the local variable:

```squirrel
local encrypted = aes.encrypt(value);
```

### decrypt(*cipherBlob*)

Decrypts the specified cipher. The `cipherBlob` must be 16 byte long `blob`. The function returns
a blob with result of the decryption process.

**Example**

The following code decrypts the value and stores it in the local variable:

```squirrel
local decrypted = aes.decrypt(cipher);
```

### hexStringToBlob(*str*)

A helper function to convert a hexadecimal string into a blob value. Returns a blob.
The function supports only specific format of strings: just hexadecimal digits/characters, for example:
`fcb5972d1e6419283b9c5a5bf7e193c4` or `ea32d4b183f0988984f1d536f15fd1f2`.
No other characters are supported and may result in unpredictable behavior.

Examples of string formats that are not supported: `0x123456`, `\x45\x89\x0f`, `x2Fx34x6F`.

**Example**

```squirrel
local keyBlob = AES.hexStringToBlob("86bd8a144720b6b0650cbde99a0db485");
local aes = AES(key);

local valueBlob = AES.hexStringToBlob("6aac72463f833e7df7335433feb4dab2");
local cipherBlob = aes.encrypt(valueBlob);

// use encrypted value here
...
```

## AES.CBC Class Usage

### constructor(*key*, *iv*)

Creates an instance of `AES.CBC` class. `key` parameter is the blob that contains the encryption key.
`iv` is the initialization vector (must be 16 bytes long).

### encrypt(*valueBlob*)

Encrypts the specified value. `valueBlob` is the value to be encrypted.
The parameter size must be multiple of 16 bytes.

### decrypt(*cipherBlob*)

Decrypts the specified cipher. `cipherBlob` is the value to be decrypted.
The value size must be multiple of 16 bytes.

**Example**

```squirrel
key <- hexStringToBlob("11111111111111111111111111111111");
value <- hexStringToBlob("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
iv <- hexStringToBlob("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");

cbc <- AES.CBC(key, iv);

encrypted <- cbc.encrypt(value);
decrypted <- cbc.decrypt(encrypted);
// decrypted == cipher
```

## Performance

#### AES
On an imp-001, a 16 byte blob is normally encrypted or decrypted in 6ms.

#### AES-CBC
On an imp-001, a 16 byte blob is normally encrypted or decrypted in 7ms; a 32 byte blob in 13ms (resulting in a 1ms overhead from CBC; which also means you could just always use the CBC version, independent of whether you actually need chaining or not).

# License

The AES library is licensed under the [MIT License](LICENSE).