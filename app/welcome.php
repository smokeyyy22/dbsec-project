<?php
require __DIR__ . '/auth.php';
$u = require_login();
?>
<!DOCTYPE html>
<html lang="fr">
<head><meta charset="utf-8"><title>Accueil</title></head>
<body>
<h1>Bienvenue, <?= htmlspecialchars($u['username'], ENT_QUOTES, 'UTF-8') ?></h1>
<p>Rôle : <strong><?= htmlspecialchars($u['role'], ENT_QUOTES, 'UTF-8') ?></strong></p>
<form method="post" action="logout.php">
  <input type="hidden" name="csrf" value="<?= htmlspecialchars(csrf_token(), ENT_QUOTES, 'UTF-8') ?>">
  <button type="submit">Se déconnecter</button>
</form>
</body>
</html>