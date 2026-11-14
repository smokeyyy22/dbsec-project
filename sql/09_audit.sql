-- 09_audit.sql : audit_log, login_attempts and triggers on sensitive tables
USE payroll_db;

CREATE TABLE IF NOT EXISTS audit_log (
  log_id      BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  event_time  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  db_user     VARCHAR(100) NOT NULL,
  app_user    VARCHAR(50)  NULL,
  action      VARCHAR(30)  NOT NULL,
  resource    VARCHAR(100) NOT NULL,
  record_id   VARCHAR(50)  NULL,
  success     BOOLEAN NOT NULL DEFAULT TRUE,
  details     VARCHAR(500) NULL,
  client_ip   VARCHAR(45)  NULL,
  INDEX idx_time (event_time),
  INDEX idx_app_user (app_user)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS login_attempts (
  attempt_id    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  attempt_time  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  username      VARCHAR(50) NOT NULL,
  success       BOOLEAN NOT NULL,
  ip_address    VARCHAR(45) NULL,
  reason        VARCHAR(100) NULL,
  INDEX idx_user_time (username, attempt_time)
) ENGINE=InnoDB;

DROP TRIGGER IF EXISTS trg_emp_ai;
DROP TRIGGER IF EXISTS trg_emp_au;
DROP TRIGGER IF EXISTS trg_emp_ad;
DROP TRIGGER IF EXISTS trg_bank_ai;
DROP TRIGGER IF EXISTS trg_bank_au;
DROP TRIGGER IF EXISTS trg_bank_ad;
DROP TRIGGER IF EXISTS trg_sal_ai;
DROP TRIGGER IF EXISTS trg_sal_au;
DROP TRIGGER IF EXISTS trg_sal_ad;

DELIMITER $$

-- employees
CREATE TRIGGER trg_emp_ai AFTER INSERT ON employees FOR EACH ROW
BEGIN
  INSERT INTO audit_log (db_user, app_user, action, resource, record_id, details)
  VALUES (USER(), @app_user, 'INSERT', 'employees', NEW.emp_id, 'employee record created');
END$$

CREATE TRIGGER trg_emp_au AFTER UPDATE ON employees FOR EACH ROW
BEGIN
  INSERT INTO audit_log (db_user, app_user, action, resource, record_id, details)
  VALUES (USER(), @app_user, 'UPDATE', 'employees', NEW.emp_id,
    CONCAT_WS(', ',
      IF(NOT (OLD.job_title   <=> NEW.job_title),   'job_title changed',   NULL),
      IF(NOT (OLD.dept_id     <=> NEW.dept_id),     'dept_id changed',     NULL),
      IF(NOT (OLD.status      <=> NEW.status),      'status changed',      NULL),
      IF(NOT (OLD.national_id <=> NEW.national_id), 'national_id changed', NULL),
      IF(NOT (OLD.email       <=> NEW.email),       'email changed',       NULL),
      IF(NOT (OLD.address     <=> NEW.address),     'address changed',     NULL)));
END$$

CREATE TRIGGER trg_emp_ad AFTER DELETE ON employees FOR EACH ROW
BEGIN
  INSERT INTO audit_log (db_user, app_user, action, resource, record_id, details)
  VALUES (USER(), @app_user, 'DELETE', 'employees', OLD.emp_id, 'employee record deleted');
END$$

-- employee_bank
CREATE TRIGGER trg_bank_ai AFTER INSERT ON employee_bank FOR EACH ROW
BEGIN
  INSERT INTO audit_log (db_user, app_user, action, resource, record_id, details)
  VALUES (USER(), @app_user, 'INSERT', 'employee_bank', NEW.emp_id, 'bank details created');
END$$

CREATE TRIGGER trg_bank_au AFTER UPDATE ON employee_bank FOR EACH ROW
BEGIN
  INSERT INTO audit_log (db_user, app_user, action, resource, record_id, details)
  VALUES (USER(), @app_user, 'UPDATE', 'employee_bank', NEW.emp_id,
    CONCAT_WS(', ',
      IF(NOT (OLD.iban      <=> NEW.iban),      'iban changed',      NULL),
      IF(NOT (OLD.bank_name <=> NEW.bank_name), 'bank_name changed', NULL)));
END$$

CREATE TRIGGER trg_bank_ad AFTER DELETE ON employee_bank FOR EACH ROW
BEGIN
  INSERT INTO audit_log (db_user, app_user, action, resource, record_id, details)
  VALUES (USER(), @app_user, 'DELETE', 'employee_bank', OLD.emp_id, 'bank details deleted');
END$$

-- salaries
CREATE TRIGGER trg_sal_ai AFTER INSERT ON salaries FOR EACH ROW
BEGIN
  INSERT INTO audit_log (db_user, app_user, action, resource, record_id, details)
  VALUES (USER(), @app_user, 'INSERT', 'salaries', NEW.emp_id,
    CONCAT('new salary ', NEW.base_salary));
END$$

CREATE TRIGGER trg_sal_au AFTER UPDATE ON salaries FOR EACH ROW
BEGIN
  INSERT INTO audit_log (db_user, app_user, action, resource, record_id, details)
  VALUES (USER(), @app_user, 'UPDATE', 'salaries', NEW.emp_id,
    CONCAT('base_salary ', OLD.base_salary, ' -> ', NEW.base_salary));
END$$

CREATE TRIGGER trg_sal_ad AFTER DELETE ON salaries FOR EACH ROW
BEGIN
  INSERT INTO audit_log (db_user, app_user, action, resource, record_id, details)
  VALUES (USER(), @app_user, 'DELETE', 'salaries', OLD.emp_id,
    CONCAT('salary deleted ', OLD.base_salary));
END$$

DELIMITER ;