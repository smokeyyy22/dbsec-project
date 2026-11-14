-- 05_roles_users.sql : rôles, utilisateurs et privilèges (MariaDB 10.11)
-- LAB UNIQUEMENT : mots de passe de test.

-- Nettoyage pour pouvoir relancer le script
DROP USER IF EXISTS 'kbenali'@'localhost';
DROP USER IF EXISTS 'salaoui'@'localhost';
DROP USER IF EXISTS 'hberrada'@'localhost';
DROP USER IF EXISTS 'otazi'@'localhost';
DROP USER IF EXISTS 'nbennani'@'localhost';
DROP USER IF EXISTS 'ychraibi'@'localhost';
DROP USER IF EXISTS 'alahlou'@'localhost';
DROP USER IF EXISTS 'app_service'@'localhost';
DROP ROLE IF EXISTS role_dba, role_hr, role_accountant, role_manager, role_employee, role_app;

-- 1. Rôles
CREATE ROLE role_dba;
CREATE ROLE role_hr;
CREATE ROLE role_accountant;
CREATE ROLE role_manager;
CREATE ROLE role_employee;
CREATE ROLE role_app;

-- 2. Privilèges des rôles (moindre privilège)

-- DBA : tout sur payroll_db seulement (pas de GRANT OPTION, pas de droits globaux)
GRANT ALL PRIVILEGES ON payroll_db.* TO role_dba;

-- HR : lit les employés SAUF national_id, peut en créer/modifier, lit les salaires
GRANT SELECT, INSERT, UPDATE ON payroll_db.departments TO role_hr;
GRANT SELECT (emp_id, first_name, last_name, email, phone, address, birth_date,
              hire_date, job_title, dept_id, manager_id, status, created_at)
      ON payroll_db.employees TO role_hr;
GRANT INSERT, UPDATE ON payroll_db.employees TO role_hr;
GRANT SELECT ON payroll_db.salaries TO role_hr;

-- Accountant : paie, salaires, coordonnées bancaires, identité via vue
GRANT SELECT ON payroll_db.departments TO role_accountant;
GRANT SELECT ON payroll_db.v_employees_basic TO role_accountant;
GRANT SELECT ON payroll_db.employee_bank TO role_accountant;
GRANT SELECT, INSERT, UPDATE ON payroll_db.salaries TO role_accountant;
GRANT SELECT, INSERT, UPDATE ON payroll_db.payroll TO role_accountant;

-- Manager : son équipe uniquement, via vue
GRANT SELECT ON payroll_db.departments TO role_manager;
GRANT SELECT ON payroll_db.v_team_employees TO role_manager;

-- Employee : ses propres données, via les vues v_my_*
GRANT SELECT ON payroll_db.v_my_profile TO role_employee;
GRANT SELECT ON payroll_db.v_my_bank TO role_employee;
GRANT SELECT ON payroll_db.v_my_salaries TO role_employee;
GRANT SELECT ON payroll_db.v_my_payroll TO role_employee;

-- Compte de service de l'application : strict minimum
GRANT SELECT ON payroll_db.departments TO role_app;
GRANT SELECT (emp_id, first_name, last_name, email, phone, address, birth_date,
              hire_date, job_title, dept_id, manager_id, status, created_at)
      ON payroll_db.employees TO role_app;
GRANT SELECT ON payroll_db.app_users TO role_app;
GRANT UPDATE (failed_attempts, locked_until, last_login) ON payroll_db.app_users TO role_app;

-- 3. Utilisateurs (mêmes noms que les comptes de l'application)
CREATE USER 'kbenali'@'localhost'     IDENTIFIED BY 'Db#kbenali2026';
CREATE USER 'salaoui'@'localhost'     IDENTIFIED BY 'Db#salaoui2026';
CREATE USER 'hberrada'@'localhost'    IDENTIFIED BY 'Db#hberrada2026';
CREATE USER 'otazi'@'localhost'       IDENTIFIED BY 'Db#otazi2026';
CREATE USER 'nbennani'@'localhost'    IDENTIFIED BY 'Db#nbennani2026';
CREATE USER 'ychraibi'@'localhost'    IDENTIFIED BY 'Db#ychraibi2026';
CREATE USER 'alahlou'@'localhost'     IDENTIFIED BY 'Db#alahlou2026';
CREATE USER 'app_service'@'localhost' IDENTIFIED BY 'Svc#app2026';

-- 4. Attribution des rôles
GRANT role_dba        TO 'kbenali'@'localhost';
GRANT role_hr         TO 'salaoui'@'localhost';
GRANT role_accountant TO 'hberrada'@'localhost';
GRANT role_accountant TO 'otazi'@'localhost';
GRANT role_manager    TO 'nbennani'@'localhost';
GRANT role_employee   TO 'ychraibi'@'localhost';
GRANT role_employee   TO 'alahlou'@'localhost';
GRANT role_app        TO 'app_service'@'localhost';

-- 5. Rôle activé automatiquement à la connexion
SET DEFAULT ROLE role_dba        FOR 'kbenali'@'localhost';
SET DEFAULT ROLE role_hr         FOR 'salaoui'@'localhost';
SET DEFAULT ROLE role_accountant FOR 'hberrada'@'localhost';
SET DEFAULT ROLE role_accountant FOR 'otazi'@'localhost';
SET DEFAULT ROLE role_manager    FOR 'nbennani'@'localhost';
SET DEFAULT ROLE role_employee   FOR 'ychraibi'@'localhost';
SET DEFAULT ROLE role_employee   FOR 'alahlou'@'localhost';
SET DEFAULT ROLE role_app        FOR 'app_service'@'localhost';

FLUSH PRIVILEGES;