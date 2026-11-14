\# Matrice de contrôle d'accès (payroll\_db)



S = SELECT, I = INSERT, U = UPDATE, D = DELETE, - = aucun accès.

"vue" = accès uniquement via une vue (colonnes sensibles masquées ou lignes filtrées).



| Table | DBA | HR | Accountant | Manager | Employee | app\_service |

|---|---|---|---|---|---|---|

| departments | S I U D | S I U | S | S | - | S |

| employees | S I U D | S I U | S (vue, sans national\_id) | S (vue, son département, sans national\_id) | S (vue, sa ligne) | S |

| employee\_bank | S I U D | - | S | - | S (vue, sa ligne) | - |

| salaries | S I U D | S | S I U | - | S (vue, sa ligne) | - |

| payroll | S I U D | - | S I U | - | S (vue, sa ligne) | - |

| app\_users | S I U D | - | - | - | - | S + U sur failed\_attempts, locked\_until, last\_login |



\## Justifications

\- Aucun rôle métier n'a DELETE : on désactive (is\_active) pour conserver l'historique d'audit.

\- employee\_bank est séparée : HR ne voit jamais les IBAN, seul l'accountant y accède.

\- app\_users est réservée : personne ne lit les hashes sauf le DBA et le compte de service.

\- Le manager n'a aucun accès aux salaires : il a besoin de l'organisation, pas de la paie.

\- national\_id et iban sont masqués dans les vues : seul le DBA y accède.

\- app\_service a le minimum nécessaire pour l'application (principe du moindre privilège).

