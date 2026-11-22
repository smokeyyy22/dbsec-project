# Controls evidence (provisional: masking policy under review)

| File | What it shows | Threat |
|---|---|---|
| 10_encryption_proof.png | national_id and iban stored as ciphertext (terminal) | T5 |
| 10_sensitive_hr.png | sensitive.php as salaoui (hr): national ID in clear, IBAN masked (last 4) | T5 |
| 10_sensitive_dba.png | sensitive.php as kbenali (dba): national ID and IBAN masked (last 4) | T5 |
| 10_sensitive_accountant.png | sensitive.php as hberrada (accountant): IBAN in clear, national ID [restricted] | T5 |
| 10_welcome_manager.png | Login as nbennani succeeded, role manager (welcome.php) | T4 |
| 10_sensitive_manager_403.png | sensitive.php as nbennani (manager): "Accès refusé." (URL visible) | T4 |
| 10_audit_read_sensitive.png | READ_SENSITIVE events for hr, dba and accountant in audit_log; db_user is still root; the denied manager attempt is not logged | T7 |

## Notes
- The HR and DBA captures must be redone if the masking policy changes (it currently conflicts with docs/access-matrix.md).
- `db_user` is `root@localhost` in the audit rows because the app still connects as root (hardening item).
- Denied access attempts (403) are not written to `audit_log`.
