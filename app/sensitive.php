<?php
require_once __DIR__ . '/auth.php';
require_once __DIR__ . '/db.php';
require_once __DIR__ . '/crypto.php';
require_once __DIR__ . '/audit.php';

$user = require_role('dba', 'hr', 'accountant');
$pdo  = get_pdo();

$rows = $pdo->query(
    'SELECT e.emp_id, e.first_name, e.last_name, e.national_id, b.iban
     FROM employees e
     LEFT JOIN employee_bank b ON b.emp_id = e.emp_id
     ORDER BY e.emp_id'
)->fetchAll();
audit_event($user['username'], 'READ_SENSITIVE',
    'employees.national_id, employee_bank.iban', null, true,
    'viewed ' . count($rows) . ' records as role ' . $user['role']);
?>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"><title>Sensitive data</title></head>
<body>
<h1>Protected data view</h1>
<p>Logged in as <b><?= htmlspecialchars($user['username']) ?></b>
   (role: <b><?= htmlspecialchars($user['role']) ?></b>)</p>
<table border="1" cellpadding="6">
  <tr><th>ID</th><th>Name</th><th>National ID</th><th>IBAN</th></tr>
  <?php foreach ($rows as $r): ?>
  <tr>
    <td><?= (int) $r['emp_id'] ?></td>
    <td><?= htmlspecialchars($r['first_name'] . ' ' . $r['last_name']) ?></td>
    <td><?= htmlspecialchars(reveal_field($r['national_id'], $user['role'], 'national_id')) ?></td>
    <td><?= htmlspecialchars(reveal_field($r['iban'] ?? '', $user['role'], 'iban')) ?></td>
  </tr>
  <?php endforeach; ?>
</table>
<p><a href="logout.php">Logout</a></p>
</body>
</html>