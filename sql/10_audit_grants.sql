-- 10_audit_grants.sql : append-only access to login_attempts for the app account
GRANT INSERT ON payroll_db.login_attempts TO 'app_service'@'localhost';