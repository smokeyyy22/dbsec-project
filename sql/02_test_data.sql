USE payroll_db;

INSERT INTO departments (dept_name, location) VALUES
('IT', 'Rabat'),
('Human Resources', 'Rabat'),
('Finance', 'Casablanca'),
('Operations', 'Casablanca');

INSERT INTO employees (first_name, last_name, email, phone, address, birth_date, hire_date, job_title, dept_id, manager_id, national_id) VALUES
('Karim',   'Benali',  'karim.benali@example.test',   '0600000001', '12 Rue Atlas, Rabat',       '1985-03-14', '2018-01-15', 'Database Administrator', 1, NULL, 'AB100001'),
('Sara',    'Alaoui',  'sara.alaoui@example.test',    '0600000002', '8 Avenue Hassan II, Rabat', '1988-07-22', '2019-03-01', 'HR Officer',             2, NULL, 'AB100002'),
('Hind',    'Berrada', 'hind.berrada@example.test',   '0600000003', '45 Bd Zerktouni, Casa',     '1982-11-05', '2016-09-12', 'Finance Manager',        3, NULL, 'AB100003'),
('Nadia',   'Bennani', 'nadia.bennani@example.test',  '0600000004', '3 Rue Ibn Sina, Casa',      '1984-01-30', '2017-05-20', 'Operations Manager',     4, NULL, 'AB100004'),
('Omar',    'Tazi',    'omar.tazi@example.test',      '0600000005', '27 Rue Moulay Youssef, Casa','1991-09-18','2021-02-08', 'Accountant',             3, 3,    'AB100005'),
('Yassine', 'Chraibi', 'yassine.chraibi@example.test','0600000006', '19 Rue Agdal, Rabat',       '1994-05-09', '2022-06-01', 'Software Developer',     1, 1,    'AB100006'),
('Amine',   'Lahlou',  'amine.lahlou@example.test',   '0600000007', '6 Rue Maarif, Casa',        '1996-12-02', '2023-01-16', 'Operations Agent',       4, 4,    'AB100007'),
('Imane',   'Kettani', 'imane.kettani@example.test',  '0600000008', '14 Rue Gauthier, Casa',     '1995-04-27', '2023-04-03', 'Operations Agent',       4, 4,    'AB100008'),
('Reda',    'Skalli',  'reda.skalli@example.test',    '0600000009', '31 Rue Hay Riad, Rabat',    '1993-08-11', '2022-09-19', 'Software Developer',     1, 1,    'AB100009'),
('Zineb',   'Amrani',  'zineb.amrani@example.test',   '0600000010', '22 Rue Souissi, Rabat',     '1998-02-16', '2024-02-05', 'HR Assistant',           2, 2,    'AB100010');

INSERT INTO employee_bank (emp_id, bank_name, iban)
SELECT emp_id, 'Attijariwafa Bank', CONCAT('MA64011150000000', LPAD(emp_id, 12, '0'))
FROM employees;

INSERT INTO salaries (emp_id, base_salary, effective_from) VALUES
(1, 25000.00, '2024-01-01'),
(2, 18000.00, '2024-01-01'),
(3, 30000.00, '2024-01-01'),
(4, 28000.00, '2024-01-01'),
(5, 15000.00, '2024-01-01'),
(6, 16000.00, '2024-01-01'),
(7,  9000.00, '2024-01-01'),
(8,  9000.00, '2024-01-01'),
(9, 15500.00, '2024-01-01'),
(10, 8500.00, '2024-01-01');

INSERT INTO payroll (emp_id, pay_period, gross_pay, deductions, net_pay, status) VALUES
(1,  '2026-10-01', 25000.00, 2500.00, 22500.00, 'paid'),
(2,  '2026-10-01', 18000.00, 1800.00, 16200.00, 'paid'),
(3,  '2026-10-01', 30000.00, 3000.00, 27000.00, 'paid'),
(4,  '2026-10-01', 28000.00, 2800.00, 25200.00, 'paid'),
(5,  '2026-10-01', 15000.00, 1500.00, 13500.00, 'paid'),
(6,  '2026-10-01', 16000.00, 1600.00, 14400.00, 'paid'),
(7,  '2026-10-01',  9000.00,  900.00,  8100.00, 'paid'),
(8,  '2026-10-01',  9000.00,  900.00,  8100.00, 'paid'),
(9,  '2026-10-01', 15500.00, 1550.00, 13950.00, 'paid'),
(10, '2026-10-01',  8500.00,  850.00,  7650.00, 'paid');