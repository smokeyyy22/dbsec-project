<?php
// 07_encrypt_data.php : encrypts national_id and iban already stored in clear text.
// Safe to run twice: values that are already encrypted are skipped.
require_once __DIR__ . '/../app/crypto.php';
require_once __DIR__ . '/../app/db.php';

$pdo = get_pdo();
$pdo->beginTransaction();

$jobs = [
    ['employees',     'emp_id',  'national_id'],
    ['employee_bank', 'bank_id', 'iban'],
];

foreach ($jobs as [$table, $pk, $col]) {
    $rows = $pdo->query("SELECT $pk AS id, $col AS val FROM $table")->fetchAll();
    $upd  = $pdo->prepare("UPDATE $table SET $col = ? WHERE $pk = ?");
    $done = 0;
    foreach ($rows as $r) {
        if (strlen($r['val']) >= 29) {
            continue; // already encrypted (IV + tag + ciphertext is at least 29 bytes)
        }
        $upd->execute([encrypt_field($r['val']), $r['id']]);
        $done++;
    }
    echo "$table.$col : $done value(s) encrypted\n";
}

$pdo->commit();