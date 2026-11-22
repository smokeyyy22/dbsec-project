# After-hardening evidence index
| File | What it shows | Threat |
|---|---|---|
| 00_info.txt | Date, commit, branch | |
| 01_root_login.txt | Root without password is denied | T9 |
| 02_accounts_grants.txt | No anonymous or remote root; app_service least privilege | T9 |
| 03_config_php.txt | App connects as app_service, not root (password redacted) | T1, T9 |
| 04_netstat.txt, 04_mysql_vars.txt | Port 3306 on 127.0.0.1 only; local_infile OFF; test DB removed | T9 |
| 05_web_*.txt | .git, sql/, docs/, vulnerable/ return 403 | T9 |
| 06_*.txt, config/ | Apache, PHP and MariaDB settings hardened | T9 |
| 06_phpmyadmin.png | phpMyAdmin refuses a login without a password | T9 |
| 07_port_check_lan_ip.txt | Port 3306 not reachable on the LAN address (tested from the same PC; no second machine available) | T9 |
