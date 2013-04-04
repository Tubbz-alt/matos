# USERS
require 'csv'
require 'open-uri'

User.destroy_all
Report.destroy_all
Study.destroy_all
Receiver.destroy_all
Collaborator.destroy_all
Hit.destroy_all
OtnArray.destroy_all
Tag.destroy_all

puts 'SETTING UP DEFAULT USER LOGIN'
ENV['WEB_ADMIN_PASSWORD'] ||= "default"
user = User.create! :name => "Kyle Wilcox", :email => 'kwilcox@asascience.com', :password => ENV['WEB_ADMIN_PASSWORD'], :password_confirmation => ENV['WEB_ADMIN_PASSWORD'], :role => "admin", :approved => true
user.confirm!
puts 'New admin user created: ' << user.email << "/" << ENV['WEB_ADMIN_PASSWORD']
