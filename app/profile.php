<?php
require_once __DIR__ . '/auth.php';
require_once __DIR__ . '/auth_db.php';

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

// Vérifie que la fiche demandée appartient au compte connecté.
$allowed = $id === $ownId;
$profile = false;

if ($allowed) {
    $stmt = $pdo->prepare(
        'SELECT first_name, last_name FROM employees WHERE emp_id = ?'
    );
    $stmt->execute([$ownId]);
    $profile = $stmt->fetch();

    if (!$profile) {
        http_response_code(404);
    }
} else {
    http_response_code(403);
}
?>

<h1>Fiche employé — version corrigée</h1>
<p>Compte connecté : <?= htmlspecialchars($current['username']) ?></p>
<p>Identifiant de ta fiche : <?= $ownId ?></p>
<p>Identifiant demandé : <?= $id ?></p>

<?php if (!$allowed): ?>
    <p>Accès refusé. Tu peux consulter uniquement ta propre fiche.</p>
<?php elseif ($profile): ?>
    <p>Fiche affichée : <?= htmlspecialchars($profile['first_name'] . ' ' . $profile['last_name']) ?></p>
<?php else: ?>
    <p>Fiche introuvable.</p>
<?php endif; ?>