class CBCTestCase extends ImpTestCase {

    function testEncryptDecrypt() {
        // Generated some tests with http://aes.online-domain-tools.com

        _verifyEncryptDecrypt(
            "1234567890abcdef1234567890abcdef", // key
            "df7df63f3e804feaa573936247eec9cf", // iv
            "12390942098501230abcdef81239a9eb", // value
            ""  // expectee cipher
        );

        _verifyEncryptDecrypt(
            "1234567890abcdef1234567890abcdef", // key
            "1b988f965c4aaf0b7f3c371498b017d2", // iv
            "966fd5754d0abfe3367d0a48bd2b3a068bd943c134c83e9e62a2ffe6bbba7dfa", // value
            ""  // expectee cipher
        );


        _verifyEncryptDecrypt(
            "1234567890abcdef1234567890abcdef", // key
            "fcb5972d1e6419283b9c5a5bf7e193c4", // iv
            "6aac72463f833e7df7335433feb4dab271e15a7303d9b62514936e86e1aa9eff31238faaf11061375d64920749cf4681", // value
            ""  // expectee cipher
        );
    }

    function _verifyEncryptDecrypt(key, iv, value, cipherExpected) {
        // Initialize the AES.CBC instance
        local keyBlob = AES.hexStringToBlob(key);
        local ivBlob  = AES.hexStringToBlob(iv);
        local aesCBC  = AES.CBC(keyBlob, ivBlob);

        local valueBlob          = AES.hexStringToBlob(value);
        local cipherActualBlob   = aes.encrypt(valueBlob);
        local cipherExpectedBlob = AES.hexStringToBlob(cipherExpected);

        cipherActualBlob.seek(0);
        cipherExpectedBlob.seek(0);

        // Verify encryption
        // for (local i = 0; i < cipherActualBlob.len(); i++) {
        //     local a = cipherActualBlob.readn('b');
        //     local b = cipherExpectedBlob.readn('b');
        //     assertEqual(a, b, format("Encryption failed. Expected: 0x%x, received: 0x%x", a, b));
        // }

        local cipherBlob    = AES.hexStringToBlob(value);
        local decryptedBlob = aes.decrypt(cipherActualBlob);

        cipherBlob.seek(0);
        decryptedBlob.seek(0);

        // Verify decryption
        for (local i = 0; i < cipherBlob.len(); i++) {
            local a = cipherBlob.readn('b');
            local b = decryptedBlob.readn('b');
            assertEqual(a, b, format("Decryption failed. Expected: 0x%x, received: 0x%x", a, b));
        }
    }

}