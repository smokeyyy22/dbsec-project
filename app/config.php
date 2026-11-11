<?php
// Database settings. LAB ONLY: root with no password is a known "before hardening" finding.
// Malak/Youness will replace this with a least-privileged application account.
define('DB_HOST', '127.0.0.1');
define('DB_NAME', 'payroll_db');
define('DB_USER', 'root');
define('DB_PASS', '');