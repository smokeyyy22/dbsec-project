-- 12_incident_timeline.sql : merges login_attempts and audit_log in chronological order
-- Usage: SET @t0 = '<incident start time>'; then source this file
USE payroll_db;

SELECT event_time, source, actor, event, resource, outcome, ip
FROM (
  SELECT attempt_time AS event_time, 'login_attempts' AS source,
         username AS actor, CONCAT('login: ', reason) AS event,
         'app_users' AS resource,
         IF(success, 'SUCCESS', 'FAILED') AS outcome, ip_address AS ip
  FROM login_attempts
  UNION ALL
  SELECT event_time, 'audit_log', COALESCE(app_user, db_user),
         CONCAT(action, IF(details IS NULL, '', CONCAT(': ', details))),
         resource, IF(success, 'SUCCESS', 'FAILED'), client_ip
  FROM audit_log
) t
WHERE event_time >= @t0
ORDER BY event_time;
