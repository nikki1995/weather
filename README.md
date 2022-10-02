# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: ruby 2.7.0p

* Rails version: Rails 6.1.7

* Used Weather API: Retrived Weather data from website https://openweathermap.org

* How the App Works: 

App has form which has 2 input fields zipcode, units

Zipcode: zipcode of place where you want to know the weather conditions, EX: 20871
Units: In which units you want the weather to be displayed, EX: F or C

Once submitted data app will display the current weather condition and weather forcasting

* validations:

Need to provide the correct zipcode and the zipcode field shouldn't be empty

* Steps to Build

clone app
Bundle install
rails s
Add below env variables in config/env_vars.rb(create file)
  ENV['API_KEY'] = "..."
  ENV['API_URL'] = "https://api.openweathermap.org"
  
run localhost:3000 in browser


* How to run the test suite: bundle exec rspec spec
