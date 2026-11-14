# Secure Database System: Employee and Payroll Management

Database Security continuous assessment group project (UIR, 5th year Engineering in Cybersecurity, Dr. Abdulganiyu O. Harazeem).

**LAB USE ONLY.** This project contains a deliberately vulnerable component (in `vulnerable/`) and test credentials. Never deploy it on a public or third-party system.

## System

An Employee and Payroll Management System. It stores employee identity data (including national ID), bank details, salaries and monthly payroll, with several user categories (DBA, HR, accountant, manager, employee).

## Requirements

- Windows with XAMPP (Apache, PHP 8.3, MariaDB 10.11)
- Git (Git Bash recommended)

## Repository structure

```
sql/          Database scripts (schema, test data, seed users, later: roles, audit, backup)
app/          Secure PHP application
vulnerable/   Isolated, deliberately vulnerable version (lab only)
docs/         ERD, data classification, CIA analysis, threat model
```

## Setup (reproduce the database)

1. Install XAMPP in `C:\xampp`. Open the XAMPP Control Panel and start **Apache** and **MySQL**.
2. Clone the repository into the web folder:
   ```
   cd /c/xampp/htdocs
   git clone https://github.com/smokeyyy22/dbsec-project.git
   cd dbsec-project
   ```
3. Run the scripts in this order:
   ```
   /c/xampp/mysql/bin/mysql.exe -u root < sql/01_schema.sql
   /c/xampp/mysql/bin/mysql.exe -u root < sql/02_test_data.sql
   /c/xampp/php/php.exe sql/03_seed_users.php
   ```
4. Verify the data (expected: departments 4, employees 10, employee_bank 10, salaries 10, payroll 10):
   ```
   /c/xampp/mysql/bin/mysql.exe -u root < sql/check.sql
   ```
5. Open the application: http://localhost/dbsec-project/app/index.php

To start over, drop the database and rerun step 3:
```
/c/xampp/mysql/bin/mysql.exe -u root -e "DROP DATABASE payroll_db;"
```

## Database

Database name: `payroll_db`

| Table | Content | Sensitivity |
|---|---|---|
| departments | Department names and locations | Low |
| employees | Identity, contact, job data, national ID | High |
| employee_bank | Bank name and IBAN (separate table on purpose) | High |
| salaries | Salary history per employee | High |
| payroll | Monthly payslips (gross, deductions, net) | High |
| app_users | Logins, password hashes, roles, lockout counters | Critical |

Sensitive columns `national_id` and `iban` are `VARBINARY` so they can be encrypted later. Bank data is kept in its own table so access can be granted separately (least privilege).

Design documents are in `docs/`: `erd.md` and `erd.png` (entity relationship diagram), and `security_analysis.md` (data classification, CIA analysis, threat model).

## Test accounts (lab only)

| Username | Role | Password |
|---|---|---|
| kbenali | dba | Lab#kbenali2026 |
| salaoui | hr | Lab#salaoui2026 |
| hberrada | accountant | Lab#hberrada2026 |
| nbennani | manager | Lab#nbennani2026 |
| otazi | accountant | Lab#otazi2026 |
| ychraibi | employee | Lab#ychraibi2026 |
| alahlou | employee | Lab#alahlou2026 |

All data is fictional. Passwords are stored as bcrypt hashes (`password_hash`).

### Comptes de base de données (lab uniquement)
Mêmes noms que les comptes applicatifs, créés par sql/05_roles_users.sql.
Mots de passe : Db#<nom>2026 (ex. Db#salaoui2026). Compte de service : app_service / Svc#app2026.

### Ordre d'exécution des scripts ajoutés
mysql.exe -u root < sql/04_views.sql
mysql.exe -u root < sql/05_roles_users.sql

## Known initial state (before hardening)

The database `root` user has no password, and the application currently uses it. This is documented as a "before hardening" finding and will be fixed during the hardening phase.

## Team and responsibilities

| Member | Role | Report parts |
|---|---|---|
| Salwa | Database architect, technical lead | 1 to 7 |
| Malak | Access control and authentication | 8, 9, 10 |
| Narjis | Application security (SQL injection, IDOR) | 11, 12 |
| Mariam | Data protection, auditing, incident investigation | 13, 14, 17 |
| Youness | Backup, hardening, final assessment and report | 15, 16, 18, review, conclusion |

## Team workflow

- Do not change existing tables without telling Salwa first.
- Add your scripts to `sql/` with the next number (04_, 05_, ...).
- Commit small and often: `git pull`, then `git add`, `git commit`, `git push`.
