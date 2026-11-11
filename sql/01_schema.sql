CREATE DATABASE IF NOT EXISTS payroll_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE payroll_db;

CREATE TABLE departments (
  dept_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  dept_name  VARCHAR(100) NOT NULL UNIQUE,
  location   VARCHAR(100)
) ENGINE=InnoDB;

CREATE TABLE employees (
  emp_id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name   VARCHAR(50)  NOT NULL,
  last_name    VARCHAR(50)  NOT NULL,
  email        VARCHAR(120) NOT NULL UNIQUE,
  phone        VARCHAR(20),
  address      VARCHAR(255),
  birth_date   DATE,
  hire_date    DATE NOT NULL,
  job_title    VARCHAR(100) NOT NULL,
  dept_id      INT UNSIGNED NOT NULL,
  manager_id   INT UNSIGNED NULL,
  national_id  VARBINARY(255) NOT NULL,
  status       ENUM('active','on_leave','terminated') NOT NULL DEFAULT 'active',
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_emp_dept    FOREIGN KEY (dept_id)    REFERENCES departments(dept_id),
  CONSTRAINT fk_emp_manager FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
) ENGINE=InnoDB;

CREATE TABLE employee_bank (
  bank_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  emp_id     INT UNSIGNED NOT NULL UNIQUE,
  bank_name  VARCHAR(100) NOT NULL,
  iban       VARBINARY(255) NOT NULL,
  CONSTRAINT fk_bank_emp FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
    ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE salaries (
  salary_id       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  emp_id          INT UNSIGNED NOT NULL,
  base_salary     DECIMAL(10,2) NOT NULL CHECK (base_salary > 0),
  effective_from  DATE NOT NULL,
  effective_to    DATE NULL,
  CONSTRAINT fk_sal_emp FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
) ENGINE=InnoDB;

CREATE TABLE app_users (
  user_id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  emp_id           INT UNSIGNED NULL UNIQUE,
  username         VARCHAR(50)  NOT NULL UNIQUE,
  password_hash    VARCHAR(255) NOT NULL,
  role             ENUM('dba','hr','accountant','manager','employee') NOT NULL,
  failed_attempts  TINYINT UNSIGNED NOT NULL DEFAULT 0,
  locked_until     DATETIME NULL,
  last_login       DATETIME NULL,
  is_active        BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT fk_user_emp FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
) ENGINE=InnoDB;

CREATE TABLE payroll (
  payroll_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  emp_id        INT UNSIGNED NOT NULL,
  pay_period    DATE NOT NULL,
  gross_pay     DECIMAL(10,2) NOT NULL,
  deductions    DECIMAL(10,2) NOT NULL DEFAULT 0,
  net_pay       DECIMAL(10,2) NOT NULL,
  status        ENUM('draft','approved','paid') NOT NULL DEFAULT 'draft',
  processed_by  INT UNSIGNED NULL,
  UNIQUE KEY uq_emp_period (emp_id, pay_period),
  CONSTRAINT chk_net CHECK (net_pay = gross_pay - deductions),
  CONSTRAINT fk_pay_emp  FOREIGN KEY (emp_id)       REFERENCES employees(emp_id),
  CONSTRAINT fk_pay_user FOREIGN KEY (processed_by) REFERENCES app_users(user_id)
) ENGINE=InnoDB;