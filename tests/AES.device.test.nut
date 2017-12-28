class AESTestCase extends ImpTestCase {

    function setUp() {
    }

    function testBlobToArrayOfInt32() {
        local b = blob(4);

        b.writen(0xaabbccdd, 'i');
        b.writen(0x11223344, 'i');
        b.writen(0x55667788, 'i');

        local ints = AES._blobToArrayOfInt32(b);

        assertEqual(ints[0], 0xddccbbaa, format("first int should be 0xaabbccdd, received: 0x%x", ints[0]));
        assertEqual(ints[1], 0x44332211, format("second int should be 0x11223344, received: 0x%x", ints[1]));
        assertEqual(ints[2], 0x88776655, format("third int should be 0x55667788, received: 0x%x", ints[2]));
    }

    function testEncryptDecrypt() {
        // Generated some tests with http://aes.online-domain-tools.com

        _verifyEncryptDecrypt("1234567890abcdef1234567890abcdef", "12390942098501230abcdef81239a9eb", "86bd8a144720b6b0650cbde99a0db485");
        _verifyEncryptDecrypt("1234567890abcdef1234567890abcdef", "df7df63f3e804feaa573936247eec9cf", "966fd5754d0abfe3367d0a48bd2b3a06");
        _verifyEncryptDecrypt("1234567890abcdef1234567890abcdef", "6aac72463f833e7df7335433feb4dab2", "1b988f965c4aaf0b7f3c371498b017d2");
        _verifyEncryptDecrypt("1234567890abcdef1234567890abcdef", "fcb5972d1e6419283b9c5a5bf7e193c4", "8bd943c134c83e9e62a2ffe6bbba7dfa");
        _verifyEncryptDecrypt("1234567890abcdef1234567890abcdef", "71e15a7303d9b62514936e86e1aa9eff", "31238faaf11061375d64920749cf4681");
    }

    function _verifyEncryptDecrypt(key, value, cipherExpected) {
        // Initialize AES
        local keyBlob = AES.hexStringToBlob(key);
        local aes     = AES(keyBlob);

        local valueBlob          = AES.hexStringToBlob(value);
        local cipherActualBlob   = aes.encrypt(valueBlob);
        local cipherExpectedBlob = AES.hexStringToBlob(cipherExpected);

        cipherActualBlob.seek(0);
        cipherExpectedBlob.seek(0);

        // Verify encryption
        for (local i = 0; i < cipherActualBlob.len(); i++) {
            local a = cipherActualBlob.readn('b');
            local b = cipherExpectedBlob.readn('b');
            assertEqual(a, b, format("Encryption failed. Expected: 0x%x, received: 0x%x", a, b));
        }

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