-- 06_revoke_demo.sql : démonstration de REVOKE (lab uniquement)
USE payroll_db;
SHOW GRANTS FOR role_accountant;
REVOKE UPDATE ON payroll_db.salaries FROM role_accountant;
SHOW GRANTS FOR role_accountant;
-- Test à faire en tant que hberrada : UPDATE salaries ... doit échouer (ERROR 1142)
GRANT UPDATE ON payroll_db.salaries TO role_accountant;
SHOW GRANTS FOR role_accountant;