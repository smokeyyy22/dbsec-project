<?php
require __DIR__ . '/auth.php';
start_secure_session();
if ($_SERVER['REQUEST_METHOD'] === 'POST' && csrf_check($_POST['csrf'] ?? null)) {
    destroy_session();
}
header('Location: login.php');
exit;