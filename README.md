Smoothie Funds
===============
Smoothie Funds allows you to manage your money with ease.
You can get more complicated, but it's useless!

How To
-------
Start PostgreSQL server (on Archlinux):
> sudo systemctl start postgresql

Load fixture in dev environnement:
> rails db:drop ; rails db:create ; rails db:migrate ; rails db:fixtures:load FIXTURES=users,accounts,categories,transactions,schedules,pending_users

Restore data from production to dev environnement:
> dropdb smoothiefunds_development
> bundle exec rails db:create RAILS_ENV=development
> bundle exec rails db:migrate RAILS_ENV=development
> pg_restore --no-acl --no-owner --data-only --dbname=smoothiefunds_development db.dump

Miscellaneous:
> bundle exec annotate  
> bundle exec rake erd

---
Remember
---------
What to test:
> **Controllers Tests:**
> - was the web request successful?
> - was the user redirected to the right page?
> - was the user successfully authenticated?
> - was the correct object stored in the response template?
> - was the appropriate message displayed to the user in the view?
> 
> **Integration Testing :**
> - test the interaction among any number of controllers
> - test important work flows within your application

Convention d'indexation :
> 1. les colonnes composant la clef
> 2. les colonnes composant les clefs étrangères
> 3. les colonnes composant les contraintes d'unicité
> 4. les colonnes dotées de contraintes de validité
> 5. les colonnes fréquemment mises en relation, indépendamment des jointures naturelles
> 6. les colonnes les plus sollicitées par les recherches

Words of wisdom:
> When you use product_url, you’ll get the full enchilada with protocol and 
> domain name, like http://example.com/products/1. That’s the thing to use when 
> you’re doing redirect_to because the HTTP spec requires a fully qualified URL 
> when doing 302 Redirect and friends. You also need the full URL if you’re 
> redirecting from one domain to another, like 
> product_url(domain: "example2.com", product: product).
> 
> The rest of the time, you can happily use product_path. This will generate 
> only the /products/1 part, and that’s all you need when doing links or 
> pointing forms, like link_to "My lovely product", product_path(product).
