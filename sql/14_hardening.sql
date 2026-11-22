-- 14_hardening.sql : close the default MariaDB accounts (lab only).
-- Run once, while root still has no password:
--   mysql.exe -u root < sql/14_hardening.sql
-- Afterwards root and the phpMyAdmin control account require a password.
-- Root password: Root#lab2026
-- phpMyAdmin control account (pma): Pma#lab2026
-- The application uses app_service (created in 05_roles_users.sql), not root.

ALTER USER 'root'@'localhost'  IDENTIFIED BY 'Root#lab2026';
ALTER USER 'root'@'127.0.0.1' IDENTIFIED BY 'Root#lab2026';
ALTER USER 'root'@'::1'       IDENTIFIED BY 'Root#lab2026';

ALTER USER 'pma'@'localhost' IDENTIFIED BY 'Pma#lab2026';

DROP USER IF EXISTS ''@'localhost';
DROP USER IF EXISTS ''@'127.0.0.1';
DROP USER IF EXISTS ''@'::1';
DROP USER IF EXISTS ''@'%';
DROP USER IF EXISTS 'root'@'%';

DROP DATABASE IF EXISTS test;

FLUSH PRIVILEGES;
