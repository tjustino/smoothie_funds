Reminder
=========
[Linux] sudo systemctl start postgresql  
[Mac] postgres -D /usr/local/var/postgres

rake db:drop ; rake db:create ; rake db:migrate ; rake db:fixtures:load FIXTURES=users,accounts,categories,transactions,schedules

bundle exec annotate  
rake erd

---

Convention d'indexation
========================
1. les colonnes composant la clef
2. les colonnes composant les clefs étrangères
3. les colonnes composant les contraintes d'unicité
4. les colonnes dotées de contraintes de validité
5. les colonnes fréquemment mises en relation, indépendamment des jointures naturelles
6. les colonnes les plus sollicitées par les recherches
