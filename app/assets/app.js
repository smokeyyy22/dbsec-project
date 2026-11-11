(function () {
  // Theme toggle (remembered in the browser)
  var root = document.documentElement;
  try {
    var saved = localStorage.getItem('theme');
    if (saved) root.setAttribute('data-theme', saved);
  } catch (e) {}
  var toggle = document.getElementById('themeToggle');
  if (toggle) {
    toggle.addEventListener('click', function () {
      var next = root.getAttribute('data-theme') === 'light' ? 'dark' : 'light';
      root.setAttribute('data-theme', next);
      try { localStorage.setItem('theme', next); } catch (e) {}
    });
  }

  // Count-up animation for stat numbers
  document.querySelectorAll('[data-count]').forEach(function (el) {
    var target = parseInt(el.getAttribute('data-count'), 10) || 0;
    var n = 0;
    var step = Math.max(1, Math.ceil(target / 30));
    var t = setInterval(function () {
      n = Math.min(target, n + step);
      el.textContent = n;
      if (n >= target) clearInterval(t);
    }, 25);
  });

  // Live filter on the rows already displayed (browser side only, no database query)
  var search = document.getElementById('search');
  var deptSel = document.getElementById('deptFilter');
  var rows = document.querySelectorAll('#empTable tbody tr');
  var empty = document.getElementById('empty');
  var shown = document.getElementById('shownCount');

  function applyFilter() {
    var q = (search.value || '').toLowerCase().trim();
    var d = deptSel.value;
    var count = 0;
    rows.forEach(function (tr) {
      var ok = tr.getAttribute('data-search').indexOf(q) !== -1 &&
               (d === '' || tr.getAttribute('data-dept') === d);
      tr.style.display = ok ? '' : 'none';
      if (ok) count++;
    });
    if (shown) shown.textContent = count;
    if (empty) empty.style.display = count === 0 ? 'block' : 'none';
  }
  if (search) search.addEventListener('input', applyFilter);
  if (deptSel) deptSel.addEventListener('change', applyFilter);
})();