-- 11_detection_queries.sql : queries used to detect suspicious activity
USE payroll_db;

-- D1. Brute force: an account with 3+ failed logins in the last 24 hours
SELECT 'D1 brute force' AS detection, username, ip_address,
       COUNT(*) AS failures, MIN(attempt_time) AS first_fail, MAX(attempt_time) AS last_fail
FROM login_attempts
WHERE success = 0 AND attempt_time >= NOW() - INTERVAL 1 DAY
GROUP BY username, ip_address
HAVING failures >= 3
ORDER BY failures DESC;

-- D2. Username scanning: one IP trying 2+ different unknown usernames
SELECT 'D2 username scanning' AS detection, ip_address,
       COUNT(DISTINCT username) AS distinct_unknown_users, COUNT(*) AS attempts
FROM login_attempts
WHERE reason = 'unknown user'
GROUP BY ip_address
HAVING distinct_unknown_users >= 2;

-- D3. Successful login right after failures (possible guessed password)
SELECT 'D3 success after failures' AS detection, s.username,
       s.attempt_time AS success_time, COUNT(f.attempt_id) AS prior_failures
FROM login_attempts s
JOIN login_attempts f
  ON f.username = s.username AND f.success = 0
 AND f.attempt_time < s.attempt_time
 AND f.attempt_time >= s.attempt_time - INTERVAL 15 MINUTE
WHERE s.success = 1
GROUP BY s.attempt_id, s.username, s.attempt_time
HAVING prior_failures >= 2;

-- D4. Sensitive data read outside working hours (before 08:00 or from 18:00)
SELECT 'D4 off-hours read' AS detection, event_time, app_user, resource, details
FROM audit_log
WHERE action = 'READ_SENSITIVE'
  AND (HOUR(event_time) < 8 OR HOUR(event_time) >= 18)
ORDER BY event_time;

-- D5. High-risk changes: deletions, or changes to national_id / iban
SELECT 'D5 high-risk change' AS detection, event_time, db_user, app_user,
       action, resource, record_id, details
FROM audit_log
WHERE action = 'DELETE'
   OR details LIKE '%iban changed%'
   OR details LIKE '%national_id changed%'
ORDER BY event_time;

-- D6. Changes made directly in the database, bypassing the application
SELECT 'D6 direct DB access' AS detection, event_time, db_user,
       action, resource, record_id, details
FROM audit_log
WHERE app_user IS NULL AND action IN ('INSERT','UPDATE','DELETE')
ORDER BY event_time;