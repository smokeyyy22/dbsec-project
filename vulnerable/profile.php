<?php
// Démonstration IDOR avec les données fictives du labo local.
if (!in_array($_SERVER['REMOTE_ADDR'] ?? '', ['127.0.0.1', '::1'], true)) {
    http_response_code(403);
    exit('Accès réservé au labo local.');
}

require_once __DIR__ . '/../app/auth.php';
require_once __DIR__ . '/../app/auth_db.php';

$current = require_role('employee');
$pdo = auth_db();

$stmt = $pdo->prepare('SELECT emp_id FROM app_users WHERE user_id = ?');
$stmt->execute([$current['user_id']]);
$ownId = (int) $stmt->fetchColumn();

if ($ownId < 1) {
    http_response_code(403);
    exit('Ce compte ne possède pas de fiche employé.');
}

$id = filter_var($_GET['id'] ?? $ownId, FILTER_VALIDATE_INT, [
    'options' => ['min_range' => 1],
]);

if ($id === false) {
    http_response_code(400);
    exit('Identifiant invalide.');
}

// Faille volontaire : la fiche est lue sans vérifier qu'elle appartient au compte connecté.
$stmt = $pdo->prepare(
    'SELECT first_name, last_name FROM employees WHERE emp_id = ?'
);
$stmt->execute([$id]);
$profile = $stmt->fetch();
?>

<h1>Fiche employé — version vulnérable</h1>
<p>Compte connecté : <?= htmlspecialchars($current['username']) ?></p>
<p>Identifiant de ta fiche : <?= $ownId ?></p>
<p>Identifiant demandé : <?= $id ?></p>

<?php if ($profile): ?>
    <p>Fiche affichée : <?= htmlspecialchars($profile['first_name'] . ' ' . $profile['last_name']) ?></p>
<?php else: ?>
    <p>Fiche introuvable.</p>
<?php endif; ?>