# USERS
require 'csv'
require 'open-uri'

User.delete_all
Report.delete_all
Study.delete_all
Receiver.delete_all
ReceiverDeployment.delete_all
Collaborator.delete_all
Hit.delete_all
OtnArray.delete_all
Tag.delete_all
TagDeployment.delete_all
Condition.delete_all
Submission.delete_all

puts 'SETTING UP DEFAULT USER LOGIN'
ENV['WEB_ADMIN_PASSWORD'] ||= "default"
user = User.create! :name => "Kyle Wilcox", :email => 'kwilcox@asascience.com', :password => ENV['WEB_ADMIN_PASSWORD'], :password_confirmation => ENV['WEB_ADMIN_PASSWORD'], :role => "admin", :approved => true
user.confirm!
puts 'New admin user created: ' << user.email << "/" << ENV['WEB_ADMIN_PASSWORD']
