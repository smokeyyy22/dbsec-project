<?php
// Connexion PDO du compte de service (moindre privilège). LAB UNIQUEMENT.
// Remplace root pour tout ce qui touche à l'authentification.
function auth_db(): PDO
{
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO(
            'mysql:host=127.0.0.1;dbname=payroll_db;charset=utf8mb4',
            'app_service',
            'Svc#app2026',
            [
                PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES   => false,
            ]
        );
    }
    return $pdo;
}