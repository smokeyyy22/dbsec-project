# Security Analysis: Employee and Payroll System

Database: `payroll_db` (MariaDB). Application: PHP with PDO.

## 1. Critical assets

| Asset | Why it is critical |
|---|---|
| `app_users` (password hashes, roles) | Compromise gives access to the whole application and its privileges |
| `employees.national_id` | Identity theft risk, legal exposure |
| `employee_bank.iban` | Direct financial fraud risk |
| `salaries`, `payroll` | Confidential pay data, fraud and internal conflict risk |
| Payroll integrity | A modified payslip means money paid to the wrong amount or person |
| Database availability | Employees cannot be paid if the system is down or data is lost |

## 2. Data classification

Levels: **Public**, **Internal**, **Confidential**, **Restricted** (highest).

| Table.column | Level | Justification | Data owner |
|---|---|---|---|
| departments.* | Internal | Organizational structure, low risk | HR |
| employees.first_name, last_name, job_title, dept_id | Internal | Visible inside the company | HR |
| employees.email, phone, address, birth_date | Confidential | Personal data | HR |
| employees.national_id | Restricted | Government identifier, identity theft risk | HR |
| employee_bank.bank_name | Confidential | Financial relationship | Finance |
| employee_bank.iban | Restricted | Enables financial fraud | Finance |
| salaries.* | Confidential | Individual pay is private | Finance |
| payroll.* | Confidential | Individual pay and deductions | Finance |
| app_users.password_hash | Restricted | Credential material, must never be exposed | IT / DBA |
| app_users.username, role, failed_attempts, locked_until | Confidential | Helps an attacker target accounts | IT / DBA |

## 3. Authorized users (preliminary, final matrix by Malak)

| Role | Intended access |
|---|---|
| dba | Administers the database, no business need to read salaries or national IDs |
| hr | Employee records (including national ID), no payroll amounts, no bank data |
| accountant | Salaries, payroll, bank data, minimal employee identity fields |
| manager | Own department directory only, no sensitive columns |
| employee | Own record and own payslips only |
| application account | Only the exact queries the application needs, no administrative rights |

## 4. CIA analysis

### Confidentiality

- National ID, IBAN and password hashes (Restricted) must be encrypted or hashed and shown only to roles that need them.
- Data in transit must use TLS between browser and server.
- Employees must not see other employees' pay (row-level restriction).
- Sensitive columns are masked in the interface according to role.

### Integrity

- Payroll must be consistent: `net_pay = gross_pay - deductions` (enforced by a CHECK constraint).
- Only authorized roles can modify salaries and payroll, and every change is logged.
- Foreign keys prevent orphan records, unique keys prevent duplicate payslips for the same period.
- Queries must be parameterized so user input cannot alter them (SQL injection).

### Availability

- Payroll must be available at pay time each month.
- Regular backups, with a tested restore procedure.
- Protection against accidental deletion and against account lockout abuse.
- Reduced attack surface (hardening) lowers the risk of denial of service.

## 5. Threat model

### Threat actors

| Actor | Motivation | Capability |
|---|---|---|
| External attacker | Data theft, fraud | Web attacks, SQL injection, credential guessing |
| Malicious employee | Raise own pay, read colleagues' data | Valid login, tries IDOR and privilege abuse |
| Curious or careless insider | Curiosity, mistakes | Has legitimate access, may overreach or delete by accident |
| Compromised privileged account | Any | Admin rights, can read or change anything |
| Malware or ransomware | Extortion | Encrypts or destroys data |

### Attack surfaces

| Surface | Example |
|---|---|
| Login form | Brute force, credential stuffing, weak passwords |
| Search and input fields | SQL injection |
| URL parameters (employee id) | IDOR, viewing another employee's data |
| Database network port (3306) | Direct connection from outside |
| Database accounts | Default root without password, excessive privileges |
| Backups and configuration files | Readable backups, credentials in config.php |
| Network traffic | Interception without TLS |

### Threats and planned controls

| # | Threat | Asset | Impact | Planned control | Owner |
|---|---|---|---|---|---|
| T1 | SQL injection in search or login | All data | Data theft, auth bypass | Prepared statements, validation, safe errors | Narjis |
| T2 | IDOR on employee or payslip pages | Payroll, personal data | Employee reads others' data | Server-side ownership checks | Narjis |
| T3 | Brute force on login | app_users | Account takeover | Hashing, lockout after failures | Malak |
| T4 | Privilege abuse by insider | Salaries, national ID | Data leak, fraud | RBAC, least privilege, row-level views | Malak |
| T5 | Theft of the database or a backup | national_id, iban | Identity theft, fraud | Column encryption, key management | Mariam |
| T6 | Sniffing of traffic | Credentials, personal data | Interception | TLS | Mariam |
| T7 | Unauthorized or hidden changes | Payroll integrity | Fraud undetected | Audit log, triggers, detection queries | Mariam |
| T8 | Accidental or malicious data loss | All data | Payroll cannot run | Backup and tested recovery | Youness |
| T9 | Default root account, open port, loose config | Whole database | Full compromise | Hardening, remove defaults, restrict network | Youness |
| T10 | Privileged account misuse | All data | Total exposure | Separation of duties, auditing of admin actions | Mariam, Malak |
