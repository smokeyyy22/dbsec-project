<?php
require_once __DIR__ . '/auth.php';
require_once __DIR__ . '/auth_db.php';

require_role('dba', 'hr', 'accountant');

$name = $_GET['name'] ?? '';
$employees = [];
$error = '';

if (!is_string($name) || strlen($name) > 100) {
    $error = 'Saisis un nom de 100 octets maximum.';
} elseif (trim($name) !== '') {
    try {
        $stmt = auth_db()->prepare(
            'SELECT first_name, last_name FROM employees WHERE last_name LIKE ?'
        );
        $stmt->execute(['%' . trim($name) . '%']);
        $employees = $stmt->fetchAll();
    } catch (PDOException $exception) {
        error_log($exception->getMessage());
        $error = 'La recherche est momentanément indisponible.';
    }
}
?>

<h1>Recherche par nom — version corrigée</h1>

<form method="get">
    <label>Nom de famille <input name="name" required></label>
    <button type="submit">Rechercher</button>
</form>

<?php if ($error !== ''): ?>
    <p><?= htmlspecialchars($error) ?></p>
<?php else: ?>
    <p>Résultats : <?= count($employees) ?></p>
    <ul>
        <?php foreach ($employees as $employee): ?>
            <li><?= htmlspecialchars($employee['first_name'] . ' ' . $employee['last_name']) ?></li>
        <?php endforeach; ?>
    </ul>
<?php endif; ?>