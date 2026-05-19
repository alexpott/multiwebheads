copy .env.example to .env and fill in the value for the path to your codebase.

The easiest way to install a site is to ssh into a webhead and run a drush command:
```bash
vendor/bin/drush site-install standard --db-url=mysql://drupal:drupal@db/drupal
```
NB: You will need to have required Drush in your codebase.
