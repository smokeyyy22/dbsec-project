<?php
require_once __DIR__ . '/db.php';

require_once __DIR__ . '/auth.php';
$current = require_role('dba', 'hr', 'accountant');

$rows = get_pdo()->query(
    'SELECT e.emp_id, e.first_name, e.last_name, e.email, e.job_title, d.dept_name
     FROM employees e
     JOIN departments d ON d.dept_id = e.dept_id
     ORDER BY e.emp_id'
)->fetchAll();

$total = count($rows);
$depts = array_values(array_unique(array_column($rows, 'dept_name')));
sort($depts);

function slug(string $s): string {
    return strtolower(preg_replace('/[^a-z]/i', '', $s));
}
?>
<!DOCTYPE html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Payroll System</title>
  <link rel="stylesheet" href="assets/style.css">
</head>
<body>
<div class="wrap">

  <header class="top">
    <div class="brand">
      <div class="logo">🛡️</div>
      <div>
        <h1>Employee &amp; Payroll System</h1>
        <p>Secure Database Project</p>
      </div>
    </div>
    <button class="btn" id="themeToggle" type="button">🌓 Theme</button>
  </header>

  <section class="stats">
    <div class="stat">
      <div class="label">Employees</div>
      <div class="value" data-count="<?= $total ?>">0</div>
    </div>
    <div class="stat">
      <div class="label">Departments</div>
      <div class="value" data-count="<?= count($depts) ?>">0</div>
    </div>
    <div class="stat">
      <div class="label">Showing</div>
      <div class="value" id="shownCount"><?= $total ?></div>
    </div>
  </section>

  <section class="panel">
    <div class="toolbar">
      <input id="search" type="search" placeholder="Search name, email or job title...">
      <select id="deptFilter">
        <option value="">All departments</option>
        <?php foreach ($depts as $d): ?>
          <option value="<?= htmlspecialchars(slug($d)) ?>"><?= htmlspecialchars($d) ?></option>
        <?php endforeach; ?>
      </select>
    </div>

    <div class="table-scroll">
      <table id="empTable">
        <thead>
          <tr><th>Employee</th><th class="hide-sm">Email</th><th>Job title</th><th>Department</th></tr>
        </thead>
        <tbody>
        <?php foreach ($rows as $r):
            $full = $r['first_name'] . ' ' . $r['last_name'];
            $initials = strtoupper(substr($r['first_name'], 0, 1) . substr($r['last_name'], 0, 1));
            $searchText = strtolower($full . ' ' . $r['email'] . ' ' . $r['job_title']);
        ?>
          <tr data-search="<?= htmlspecialchars($searchText) ?>" data-dept="<?= htmlspecialchars(slug($r['dept_name'])) ?>">
            <td>
              <div class="person">
                <div class="avatar"><?= htmlspecialchars($initials) ?></div>
                <div>
                  <div><?= htmlspecialchars($full) ?></div>
                  <div class="muted">ID #<?= (int)$r['emp_id'] ?></div>
                </div>
              </div>
            </td>
            <td class="hide-sm muted"><?= htmlspecialchars($r['email']) ?></td>
            <td><?= htmlspecialchars($r['job_title']) ?></td>
            <td><span class="badge dept-<?= htmlspecialchars(slug($r['dept_name'])) ?>"><?= htmlspecialchars($r['dept_name']) ?></span></td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
      <div class="empty" id="empty">No employee matches your search.</div>
    </div>
  </section>

  <footer>Lab environment · fictional data · login and role-based pages are added by the team</footer>
</div>
<script src="assets/app.js"></script>
</body>
</html>