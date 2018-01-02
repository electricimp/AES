# Advanced Encryption Standard (AES) Implementation in Squirrel #

This library implements AES-128 encryption in Squirrel. The Squirrel code is based on Richard Moore’s [JavaScript implementation](https://github.com/ricmoo/aes-js).

### Modes ###

It supports [AES-128](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) encryption and decryption. It might also support AES-192 and AES-256, but these have not been tested.

The library also supports Cipher Block Chaining (CBC) mode with custom Initial Vectors (IV), via the [*AES.CBC* sub-class](#aescbc-class-usage). More modes that were not ported are available in the [JavaScript code base](https://github.com/ricmoo/aes-js/blob/master/index.js).

### Performance ###

#### AES ####

On an imp001, a 16-byte blob is normally encrypted or decrypted in 6ms.

#### AES-CBC ####

On an imp001, a 16-byte blob is normally encrypted or decrypted in 7ms; a 32-byte blob in 13ms (resulting in a 1ms overhead from CBC; which also means you could just always use the CBC version, independent of whether you actually need chaining or not).

### Usage ###

**Note** The library operates exclusively on blobs, ie. all values passed into class instances and their methods should be blobs, and library methods all return blobs. For developers’ convenience, a helper function that converts a hexadecimal string into a blob is provided by the library: [*hexStringToBlob(string)*](#hexstringtoblobhexstring).

The library can be used in both agent and device code.

**To add this library to your project, place** `#require "AES.lib.nut:1.0.0"` **at the top of your code.**

## AES Class Usage ##

### constructor(*key*) ###

The constructor creates an instance of the *AES* class initialized with the specified *key*, which must be 128 bits (16 bytes), 192 bits (24 bytes) or 256 bits (32 bytes) long.

#### Example ####

```squirrel
#require "AES.lib.nut:1.0.0"

local aes = AES(keyBlob);
```

### encrypt(*valueBlob*) ###

This method encrypts the specified value using the key with which the AES instance was initialized. *valueBlob* must be 16-byte blob. 

The function returns a blob containing the result of the encryption process.

For string-to-blob conversions, please use [*hexStringToBlob()*](#hexstringtoblobhexstring).

#### Example ####

```squirrel
local encrypted = aes.encrypt(rawValue);
```

### decrypt(*cipherBlob*) ###

This method decrypts the specified cipher. The value of *cipherBlob* must be a 16-byte blob. 

The function returns a blob containing the result of the decryption process.

#### Example ####

```squirrel
local decrypted = aes.decrypt(encrypted);
```

### hexStringToBlob(*hexString*) ###

A helper function which converts a hexadecimal string into a blob, which it returns. The function supports one specific string format: just hexadecimal digits/characters, such as `fcb5972d1e6419283b9c5a5bf7e193c4` or `ea32d4b183f0988984f1d536f15fd1f2`, **without** an `0x` prefix.

No other characters are supported and may result in unpredictable behavior.

Examples of string formats that are not supported: `0x123456`, `\x45\x89\x0f`, `x2Fx34x6F`.

#### Example ####

```squirrel
local keyBlob = AES.hexStringToBlob("86bd8a144720b6b0650cbde99a0db485");
local aes = AES(keyBlob);

local valueBlob = AES.hexStringToBlob("6aac72463f833e7df7335433feb4dab2");
local cipherBlob = aes.encrypt(valueBlob);
```

## AES.CBC Class Usage ##

### constructor(*key*, *iv*) ##

Creates an instance of the *AES.CBC* class. The *key* parameter is a blob containing the encryption key; *iv* is the initialization vector, which must be 16 bytes long.

### encrypt(*valueBlob*) ###

This method encrypts the specified value: a blob with a length that must be a multiple of 16 bytes.

### decrypt(*cipherBlob*) ###

This method decrypts the specified cipher. The length of *cipherBlob* must be a multiple of 16 bytes.

#### Example ####

```squirrel
local key = AES.hexStringToBlob("11111111111111111111111111111111");
local iv = AES.hexStringToBlob("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb");

local cbc = AES.CBC(key, iv);

local value = AES.hexStringToBlob("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
local encrypted = cbc.encrypt(value);
local decrypted = cbc.decrypt(encrypted);
```

# License #

The AES library is licensed under the [MIT License](LICENSE).
