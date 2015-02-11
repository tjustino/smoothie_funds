Reminder
=========
[Linux] sudo systemctl start postgresql  
[Mac] postgres -D /usr/local/var/postgres9.4

rake db:drop ; rake db:create ; rake db:migrate ; rake db:fixtures:load FIXTURES=users,accounts,categories,transactions,schedules

rake db:drop ; rake db:create ; psql -d smoothiefunds_development < my_dump
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

---

MMEX : 3786 opérations du 01/01/2000 au 25/05/2014

---

                      +-------+-------+-------+-------+-------+----------------+
                      | Accou | Categ | Sched | Sessi | Trans | Users          |
+---------------------+-------+-------+-------+-------+-------+----------------+
| authorize           |   ✓   |   ✓   |   ✓   |   ✓   |   ✓   |   ✓            |
+---------------------+-------+-------+-------+-------+-------+----------------+
| set_current_user    |   ✓   |   ✓   |   ✓   |   X   |   ✓   | X new & cre, ✓ |
+---------------------+-------+-------+-------+-------+-------+----------------+
| set_current_accounts|   ✓   |   ✓   |   ✓   |   X   |   ✓   | X new & cre, ✓ |
+=====================+=======+=======+=======+=======+=======+================+
| set_current_account |       |   ✓   |   ✓   |       |   ✓   |                |
+---------------------+-------+-------+-------+-------+-------+----------------+

---

When you use product_url, you’ll get the full enchilada with protocol and domain 
name, like http://example.com/products/1. That’s the thing to use when you’re 
doing redirect_to because the HTTP spec requires a fully qualified URL when 
doing 302 Redirect and friends. You also need the full URL if you’re redirecting 
from one domain to another, like product_url(domain: "example2.com", product: product).

The rest of the time, you can happily use product_path. This will generate only 
the /products/1 part, and that’s all you need when doing links or pointing 
forms, like link_to "My lovely product", product_path(product).
