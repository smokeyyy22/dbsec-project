<?php
// audit.php : application-level audit logging (reads of sensitive data)
require_once __DIR__ . '/db.php';


function audit_event(string $appUser, string $action, string $resource,
                     ?string $recordId = null, bool $success = true,
                     ?string $details = null): void
{
    try {
        $stmt = get_pdo()->prepare(
            'INSERT INTO audit_log
             (db_user, app_user, action, resource, record_id, success, details, client_ip)
             VALUES (USER(), ?, ?, ?, ?, ?, ?, ?)'
        );
        $stmt->execute([
            $appUser, $action, $resource, $recordId,
            (int) $success, $details, $_SERVER['REMOTE_ADDR'] ?? null,
        ]);
    } catch (Throwable $e) {
        error_log('Audit failure: ' . $e->getMessage());
    }
}

function log_login_attempt(string $username, bool $success, string $reason): void
{
    try {
        $stmt = auth_db()->prepare(
            'INSERT INTO login_attempts (username, success, ip_address, reason)
             VALUES (?, ?, ?, ?)'
        );
        $stmt->execute([
            substr($username, 0, 50), (int) $success,
            $_SERVER['REMOTE_ADDR'] ?? null, $reason,
        ]);
    } catch (Throwable $e) {
        error_log('Login audit failure: ' . $e->getMessage());
    }
}