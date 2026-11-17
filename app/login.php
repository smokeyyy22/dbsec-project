<?php
require __DIR__ . '/auth.php';
require __DIR__ . '/auth_db.php';
require __DIR__ . '/audit.php';

const MAX_ATTEMPTS  = 5;
const LOCK_MINUTES  = 15;
const GENERIC_ERROR = 'Identifiants incorrects ou compte temporairement indisponible.';

start_secure_session();
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim((string)($_POST['username'] ?? ''));
    $password = (string)($_POST['password'] ?? '');

    // 1. Validation côté serveur
    if (!csrf_check($_POST['csrf'] ?? null)) {
        $error = 'Requête invalide. Rechargez la page.';
    } elseif (!preg_match('/^[A-Za-z0-9_.-]{1,50}$/', $username) || $password === '' || strlen($password) > 200) {
        $error = GENERIC_ERROR;
    } else {
        try {
            $pdo = auth_db();

            // 2. Requête préparée : aucune injection SQL possible
            $stmt = $pdo->prepare(
                'SELECT user_id, username, password_hash, role, failed_attempts, is_active,
                        (locked_until IS NOT NULL AND locked_until > NOW()) AS is_locked
                 FROM app_users WHERE username = ?'
            );
            $stmt->execute([$username]);
            $u = $stmt->fetch();

            if (!$u) {
                // Utilisateur inconnu : même coût de calcul, même message
                password_verify($password, password_hash('dummy', PASSWORD_BCRYPT));
                log_login_attempt($username, false, 'unknown user');
                $error = GENERIC_ERROR;
             
            } elseif (!$u['is_active'] || $u['is_locked']) {
                $error = GENERIC_ERROR; // on ne teste même pas le mot de passe
              log_login_attempt($username, false, 'account locked or inactive');
            } elseif (password_verify($password, $u['password_hash'])) {
                // 3. Succès
                session_regenerate_id(true); // contre la fixation de session
                $_SESSION['user_id']       = (int)$u['user_id'];
                $_SESSION['username']      = $u['username'];
                $_SESSION['role']          = $u['role'];
                $_SESSION['last_activity'] = time();
                $pdo->prepare('UPDATE app_users SET failed_attempts = 0, locked_until = NULL, last_login = NOW() WHERE user_id = ?')
                    ->execute([$u['user_id']]);
                log_login_attempt($username, true, 'login ok');
                header('Location: welcome.php');
                exit;
            } else {
                // 4. Échec : compteur, puis verrouillage à 5 échecs
                if ((int)$u['failed_attempts'] + 1 >= MAX_ATTEMPTS) {
                    $pdo->prepare('UPDATE app_users SET failed_attempts = 0, locked_until = DATE_ADD(NOW(), INTERVAL ' . LOCK_MINUTES . ' MINUTE) WHERE user_id = ?')
                        ->execute([$u['user_id']]);
                } else {
                    $pdo->prepare('UPDATE app_users SET failed_attempts = failed_attempts + 1 WHERE user_id = ?')
                        ->execute([$u['user_id']]);
                }log_login_attempt($username, false, 'wrong password');
                $error = GENERIC_ERROR;
            }
        } catch (PDOException $e) {
            error_log('login error: ' . $e->getMessage()); // détail dans le journal, jamais à l'écran
            $error = 'Erreur technique. Réessayez plus tard.';
        }
    }
}
?>
<!DOCTYPE html>
<html lang="fr">
<head><meta charset="utf-8"><title>Connexion</title></head>
<body>
<h1>Connexion (lab)</h1>
<?php if ($error): ?><p style="color:#b00"><?= htmlspecialchars($error, ENT_QUOTES, 'UTF-8') ?></p><?php endif; ?>
<form method="post" autocomplete="off">
  <input type="hidden" name="csrf" value="<?= htmlspecialchars(csrf_token(), ENT_QUOTES, 'UTF-8') ?>">
  <p><label>Utilisateur <input name="username" required maxlength="50"></label></p>
  <p><label>Mot de passe <input name="password" type="password" required maxlength="200"></label></p>
  <p><button type="submit">Se connecter</button></p>
</form>
</body>
</html>