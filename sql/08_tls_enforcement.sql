-- 08_tls_enforcement.sql : demonstrates that an account can be forced to use TLS
DROP USER IF EXISTS 'tls_demo'@'localhost';
CREATE USER 'tls_demo'@'localhost' IDENTIFIED BY 'Tls#demo2026' REQUIRE SSL;
GRANT SELECT ON payroll_db.departments TO 'tls_demo'@'localhost';