\# Secure Database System: Employee and Payroll Management



Database Security continuous assessment group project (UIR, 5th year Engineering in Cybersecurity, Dr. Abdulganiyu O. Harazeem).



\*\*LAB USE ONLY.\*\* This project contains a deliberately vulnerable component (in `vulnerable/`) and test credentials. Never deploy it on a public or third-party system.



\## System



An Employee and Payroll Management System. It stores employee identity data (including national ID), bank details, salaries and monthly payroll, with several user categories (DBA, HR, accountant, manager, employee).



\## Requirements



\- Windows with XAMPP (Apache, PHP 8.3, MariaDB 10.11)

\- Git (Git Bash recommended)



\## Repository structure



```

sql/          Database scripts (schema, test data, seed users, later: roles, audit, backup)

app/          Secure PHP application

vulnerable/   Isolated, deliberately vulnerable version (lab only)

docs/         ERD, data classification, CIA analysis, threat model

```



\## Setup (reproduce the database)



1\. Install XAMPP in `C:\\xampp`. Open the XAMPP Control Panel and start \*\*Apache\*\* and \*\*MySQL\*\*.

2\. Clone the repository into the web folder:

&#x20;  ```

&#x20;  cd /c/xampp/htdocs

&#x20;  git clone https://github.com/smokeyyy22/dbsec-project.git

&#x20;  cd dbsec-project

&#x20;  ```

3\. Run the scripts in this order:

&#x20;  ```

&#x20;  /c/xampp/mysql/bin/mysql.exe -u root < sql/01\_schema.sql

&#x20;  /c/xampp/mysql/bin/mysql.exe -u root < sql/02\_test\_data.sql

&#x20;  /c/xampp/php/php.exe sql/03\_seed\_users.php

&#x20;  ```

4\. Verify the data (expected: departments 4, employees 10, employee\_bank 10, salaries 10, payroll 10):

&#x20;  ```

&#x20;  /c/xampp/mysql/bin/mysql.exe -u root < sql/check.sql

&#x20;  ```



To start over, drop the database and rerun step 3:

```

/c/xampp/mysql/bin/mysql.exe -u root -e "DROP DATABASE payroll\_db;"

```



\## Database



Database name: `payroll\_db`



| Table | Content | Sensitivity |

|---|---|---|

| departments | Department names and locations | Low |

| employees | Identity, contact, job data, national ID | High |

| employee\_bank | Bank name and IBAN (separate table on purpose) | High |

| salaries | Salary history per employee | High |

| payroll | Monthly payslips (gross, deductions, net) | High |

| app\_users | Logins, password hashes, roles, lockout counters | Critical |



Sensitive columns `national\_id` and `iban` are `VARBINARY` so they can be encrypted later. Bank data is kept in its own table so access can be granted separately (least privilege).



\## Test accounts (lab only)



| Username | Role | Password |

|---|---|---|

| kbenali | dba | Lab#kbenali2026 |

| salaoui | hr | Lab#salaoui2026 |

| hberrada | accountant | Lab#hberrada2026 |

| nbennani | manager | Lab#nbennani2026 |

| otazi | accountant | Lab#otazi2026 |

| ychraibi | employee | Lab#ychraibi2026 |

| alahlou | employee | Lab#alahlou2026 |



All data is fictional. Passwords are stored as bcrypt hashes (`password\_hash`).



\## Known initial state (before hardening)



The database `root` user has no password, and the application currently uses it. This is documented as a "before hardening" finding and will be fixed during the hardening phase.



\## Team and responsibilities



| Member | Role | Report parts |

|---|---|---|

| Salwa | Database architect, technical lead | 1 to 7 |

| Malak | Access control and authentication | 8, 9, 10 |

| Narjis | Application security (SQL injection, IDOR) | 11, 12 |

| Mariam | Data protection, auditing, incident investigation | 13, 14, 17 |

| Youness | Backup, hardening, final assessment and report | 15, 16, 18, review, conclusion |



\## Team workflow



\- Do not change existing tables without telling Salwa first.

\- Add your scripts to `sql/` with the next number (04\_, 05\_, ...).

\- Commit small and often: `git pull`, then `git add`, `git commit`, `git push`.

