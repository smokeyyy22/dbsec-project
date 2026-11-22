# Before-hardening evidence index
| File | What it shows | Threat |
|---|---|---|
| 00_info.txt | Date, commit, branch, notes | |
| 01_root_login.txt | Root connects with no password | T9 |
| 02_accounts_grants.txt | DB accounts, anonymous users, test database | T9 |
| 03_config_php.txt | App connects as root | T1, T9 |
| 04_netstat.txt, 04_mysql_vars.txt | Port 3306 binding and server variables | T9 |
| 05_web_*.txt | .git, sql/, docs/ reachable by URL | T9 |
| 06_*.txt, config/ | PHP, Apache and MariaDB settings | T9 |
| 07_nmap_from_other_pc.png | Ports 80 and 3306 reachable from another machine, .git/config readable, vulnerable/ blocked from outside, version headers exposed | T9, T1 |
| 07_web_git_exposed.png | .git/config readable in a browser | T9 |
| 07_vulnerable_page.png | Lab page served from the web root | T1 |
