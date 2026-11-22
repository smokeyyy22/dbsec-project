-- Dedicated backup account: read-only, no write access, no DROP.
CREATE USER IF NOT EXISTS 'backup_user'@'localhost' IDENTIFIED BY 'Bk#backup2026';
GRANT SELECT, LOCK TABLES, SHOW VIEW, TRIGGER, EVENT ON payroll_db.* TO 'backup_user'@'localhost';
