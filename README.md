# Start Up Rails 4 app with Devise, Omniauth, Cancan, Rolify and Bootstrap 3 in mysql

## About this app
This Rails 4.0 app uses Devise, CanCan, Rolify, OmniAuth and Bootstrap 3.

This app base can be found at [https://github.com/pratik60/rails4-bootstrap-devise-cancan-omniauth](https://github.com/pratik60/rails4-bootstrap-devise-cancan-omniauth).
The integration with bootstrap 3 was based on project [http://rvg.me/2013/11/adding-a-bootstrap-3-layout-to-a-rails-4-project/](http://rvg.me/2013/11/adding-a-bootstrap-3-layout-to-a-rails-4-project/).

The most important changes in this fork are:

*   Added Rolify gem and the Role model (user management model has to use a RDBMS (i.e. MySQL), however for the remain model, developers can choose to use a Non-Relational DB (i.e. mongoDB));
*   Added more OmniAuth providers;
*   "Complete your user information" form, if the OmniAuth (callback) doesn't have all the app "mandatory" user fields;
*   Added Bootstrap 3;
*   Added high_voltage for static pages.



## How to use
1) Update App configurations on the following files:

*   config/database.yml to set the desired database (examples can be found at config/examples)
*   config/config.yml to set some global variables
*   config/environments/development.rb to add correct settings for email
*   config/application.rb to add set app timezone and language
*   config/initializers/devise.rb to set email and external services app_id's, and secret's key (i.e. - facebook, twitter, ...)

2) Run `` rake db:migrate ``

4) Run `` rake db:seeds`` to load first user (admin)

5) Run `` rails s ``

6) Have fun!
