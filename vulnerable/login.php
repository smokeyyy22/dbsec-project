<?php
if (!in_array($_SERVER['REMOTE_ADDR'] ?? '', ['127.0.0.1', '::1'], true)) {
    http_response_code(403);
    exit('Accès réservé au labo local.');
}

require_once __DIR__ . '/../app/auth_db.php';

$message = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';

    if (is_string($username) && trim($username) !== '') {
        try {
            // Faille volontaire : l'identifiant est inséré directement dans le SQL.
            $sql = "SELECT username FROM app_users
                    WHERE username = '$username' AND is_active = 1";
            $account = auth_db()->query($sql)->fetch();

            $message = $account
                ? 'Compte sélectionné : ' . $account['username']
                : 'Aucun compte trouvé.';
        } catch (PDOException $exception) {
            $message = 'La recherche du compte a échoué.';
        }
    }
}
?>

<h1>Démo du login — recherche de compte vulnérable</h1>

<form method="post">
    <label>Utilisateur <input name="username" required></label>
    <button type="submit">Chercher le compte</button>
</form>

<p><?= htmlspecialchars($message, ENT_QUOTES, 'UTF-8') ?></p>