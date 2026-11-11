<?php
// LAB ONLY: creates test accounts with hashed passwords.
$pdo = new PDO('mysql:host=127.0.0.1;dbname=payroll_db;charset=utf8mb4', 'root', '', [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);

$users = [
    ['kbenali',   1, 'dba'],
    ['salaoui',   2, 'hr'],
    ['hberrada',  3, 'accountant'],
    ['nbennani',  4, 'manager'],
    ['otazi',     5, 'accountant'],
    ['ychraibi',  6, 'employee'],
    ['alahlou',   7, 'employee'],
];

$stmt = $pdo->prepare('INSERT IGNORE INTO app_users (emp_id, username, password_hash, role) VALUES (?, ?, ?, ?)');

foreach ($users as [$u, $empId, $role]) {
    $pw = "Lab#{$u}2026";
    $hash = password_hash($pw, PASSWORD_DEFAULT);
    $stmt->execute([$empId, $u, $hash, $role]);
    echo "$u | $pw | $role | " . substr($hash, 0, 7) . "\n";
}