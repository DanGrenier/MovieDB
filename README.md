# MovieDB

This is a small API that creates and retrieves
movie metadata and allows users to score
the movies :

* Ruby 2.5

* Rails 5.2.2

* Active Model Serializers

* json_api

* Rspec and FactoryBot for testing

* Clone the repository and run bundle install

* Copy the database.yml from the config/sample folder to the config folder

* Make sure postgresql is installed on the local machine

* Replac your_user_name and your_password in the database.yml file with the credentials needed to connect to your postgresql server

* If you don't know what the credentials are, simply use your local machine username and remove the password attribute from the file

* run: rails db:create , rails db:migrate and rails db:seed (if you want some sample data loaded)

* run: bundle exec rspec and every test should be passing


