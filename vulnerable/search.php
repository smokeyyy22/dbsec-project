<?php
// Démonstration sur le labo XAMPP local avec des données fictives.
if (!in_array($_SERVER['REMOTE_ADDR'] ?? '', ['127.0.0.1', '::1'], true)) {
    http_response_code(403);
    exit('Accès réservé au labo local.');
}

require_once __DIR__ . '/../app/auth.php';
require_once __DIR__ . '/../app/auth_db.php';

require_role('dba', 'hr', 'accountant');

$name = $_GET['name'] ?? '';
$employees = [];

if (is_string($name) && trim($name) !== '') {
    // Faille volontaire : le nom saisi est intégré directement dans le SQL.
    $sql = "SELECT first_name, last_name FROM employees
            WHERE last_name LIKE '%$name%'";
    $employees = auth_db()->query($sql)->fetchAll();
}
?>

<h1>Recherche par nom — version vulnérable</h1>

<form method="get">
    <label>Nom de famille <input name="name" required></label>
    <button type="submit">Rechercher</button>
</form>

<p>Résultats : <?= count($employees) ?></p>
<ul>
    <?php foreach ($employees as $employee): ?>
        <li><?= htmlspecialchars($employee['first_name'] . ' ' . $employee['last_name']) ?></li>
    <?php endforeach; ?>
</ul>