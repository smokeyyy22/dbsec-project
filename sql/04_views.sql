-- 04_views.sql : vues de restriction par colonne et par ligne
USE payroll_db;

-- Accountant : identité de base, sans national_id, adresse ni date de naissance
CREATE OR REPLACE SQL SECURITY DEFINER VIEW v_employees_basic AS
SELECT emp_id, first_name, last_name, email, job_title, dept_id, hire_date, status
FROM employees;

-- Manager : uniquement les employés de son propre département
CREATE OR REPLACE SQL SECURITY DEFINER VIEW v_team_employees AS
SELECT e.emp_id, e.first_name, e.last_name, e.email, e.phone,
       e.job_title, e.dept_id, e.hire_date, e.status
FROM employees e
JOIN employees m   ON m.dept_id = e.dept_id
JOIN app_users u   ON u.emp_id = m.emp_id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

-- Employee : sa propre fiche (sans national_id)
CREATE OR REPLACE SQL SECURITY DEFINER VIEW v_my_profile AS
SELECT e.emp_id, e.first_name, e.last_name, e.email, e.phone, e.address,
       e.birth_date, e.hire_date, e.job_title, e.dept_id, e.status
FROM employees e
JOIN app_users u ON u.emp_id = e.emp_id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

-- Employee : ses coordonnées bancaires
CREATE OR REPLACE SQL SECURITY DEFINER VIEW v_my_bank AS
SELECT b.emp_id, b.bank_name, b.iban
FROM employee_bank b
JOIN app_users u ON u.emp_id = b.emp_id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

-- Employee : ses salaires
CREATE OR REPLACE SQL SECURITY DEFINER VIEW v_my_salaries AS
SELECT s.salary_id, s.base_salary, s.effective_from, s.effective_to
FROM salaries s
JOIN app_users u ON u.emp_id = s.emp_id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1);

-- Employee : ses fiches de paie validées (pas les brouillons)
CREATE OR REPLACE SQL SECURITY DEFINER VIEW v_my_payroll AS
SELECT p.payroll_id, p.pay_period, p.gross_pay, p.deductions, p.net_pay, p.status
FROM payroll p
JOIN app_users u ON u.emp_id = p.emp_id
WHERE u.username = SUBSTRING_INDEX(USER(), '@', 1)
  AND p.status <> 'draft';