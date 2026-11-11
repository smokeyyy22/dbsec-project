USE payroll_db;
SELECT 'departments' AS tbl, COUNT(*) AS n FROM departments
UNION ALL SELECT 'employees', COUNT(*) FROM employees
UNION ALL SELECT 'employee_bank', COUNT(*) FROM employee_bank
UNION ALL SELECT 'salaries', COUNT(*) FROM salaries
UNION ALL SELECT 'payroll', COUNT(*) FROM payroll;
