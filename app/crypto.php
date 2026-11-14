<?php
// crypto.php : AES-256-GCM encryption of sensitive fields (national_id, iban)
// The key is stored OUTSIDE the web root and OUTSIDE the Git repository.

function crypto_key(): string {
    static $key = null;
    if ($key === null) {
        $file = getenv('DBSEC_KEY_FILE') ?: dirname(__DIR__, 3) . '/secrets/data.key';
        $hex = is_readable($file) ? trim(file_get_contents($file)) : '';
        if (!preg_match('/^[0-9a-f]{64}$/i', $hex)) {
            error_log('Encryption key missing or invalid');
            throw new RuntimeException('Service unavailable.');
        }
        $key = hex2bin($hex);
    }
    return $key;
}

// Output format: IV (12 bytes) + auth tag (16 bytes) + ciphertext
function encrypt_field(string $plain): string {
    $iv = random_bytes(12);
    $ct = openssl_encrypt($plain, 'aes-256-gcm', crypto_key(), OPENSSL_RAW_DATA, $iv, $tag);
    return $iv . $tag . $ct;
}

function decrypt_field(string $blob): ?string {
    if (strlen($blob) < 29) {
        return null;
    }
    $iv  = substr($blob, 0, 12);
    $tag = substr($blob, 12, 16);
    $ct  = substr($blob, 28);
    $plain = openssl_decrypt($ct, 'aes-256-gcm', crypto_key(), OPENSSL_RAW_DATA, $iv, $tag);
    return $plain === false ? null : $plain;
}