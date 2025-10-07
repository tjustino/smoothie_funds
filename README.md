# Smoothie Funds
Smoothie Funds allows you to manage your money with ease.


## Usual commands
Start PostgreSQL server (on Archlinux):
```sh
sudo systemctl start postgresql
```

Load fixture in dev environnement:
```sh
rm db/schema.rb ; bin/rails db:reset ; bin/rails db:migrate && bin/rails db:fixtures:load FIXTURES=users,accounts,categories,transactions,schedules,pending_users,searches,search_targets ; bundle exec annotaterb models
```

Restore data from production to dev environnement:
```sh
dropdb smoothiefunds_development
createdb smoothiefunds_development
pg_restore --clean --if-exists --dbname=smoothiefunds_development db.dump
pg_restore --clean --if-exists --no-owner --dbname=smoothiefunds_development db.dump
```

Miscellaneous:
```sh
bundle exec annotaterb models
```


## Listing Existing Routes
http://localhost:3000/rails/info/routes
or
```sh
bin/rails routes --expanded
```


## Audit query
```sql
SELECT
  users.email,
  TO_CHAR(users.created_at, 'DD/MM/YYYY') AS user_creation,
  accounts.name AS account_name,
  accounts.hidden,
  COUNT(transactions.id) AS nb_transactions,
  TO_CHAR(MAX(transactions.updated_at), 'DD/MM/YYYY') AS last_transaction
FROM users
  LEFT JOIN relations ON users.id = relations.user_id
  LEFT JOIN accounts ON relations.account_id = accounts.id
  LEFT JOIN transactions ON relations.account_id = transactions.account_id
WHERE
  transactions.schedule_id IS NULL
GROUP BY users.email, users.created_at, accounts.name, accounts.hidden
ORDER BY users.email, accounts.name;
```

## Remember
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
> When you use *product_url*, you’ll get the full enchilada with protocol and
> domain name, like http://example.com/products/1. That’s the thing to use when
> you’re doing redirect_to because the HTTP spec requires a fully qualified URL
> when doing 302 Redirect and friends. You also need the full URL if you’re
> redirecting from one domain to another, like
> *product_url(domain: "example2.com", product: product)*.
>
> The rest of the time, you can happily use *product_path*. This will generate
> only the */products/1* part, and that’s all you need when doing links or
> pointing forms, like *link_to "My lovely product", product_path(product)*.

[Testing like the TSA](https://signalvnoise.com/posts/3159-testing-like-the-tsa) :
> Don’t aim for 100% coverage.
> Code-to-test ratios above 1:2 is a smell, above 1:3 is a stink.
