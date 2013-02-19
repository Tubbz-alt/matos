set :application, "MATOS"
set :scm, :git
set :repository,  "git@github.com:asascience-open/matos.git"
set :user, "matos"
set :use_sudo, false
set :branch, "master"
set :keep_releases, 5
set :deploy_via, :remote_cache

task :production do
  set :deploy_to, "/home/matos/production"
  set :rails_env, "production"
  set :domain, "matos.asascience.com"
  role :web, "matos.asascience.com"
  role :db, "matos.asascience.com", :primary => true
end

task :staging do
  set :deploy_to, "/home/matos/staging"
  set :rails_env, "staging"
  set :domain, "matos.asascience.com"
  role :web, "matos.asascience.com"
  role :db, "matos.asascience.com", :primary => true
end

before "deploy:assets:precompile", "deploy:bundle_install"
after  "deploy:update_code","deploy:migrate"
after  "deploy:update_code","deploy:build_missing_paperclip_styles"
after  "deploy:assets:symlink","deploy:symlink_db"
after  "deploy:update", "deploy:cleanup"

namespace :deploy do
  task :bundle_install, :roles => :web do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle install"
  end
  task :bundle_update, :roles => :web do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle update"
  end
  task :restart, :roles => :web do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle exec thin -e ${rails_env} -s 2 -d restart --socket /tmp/thin.#{rails_env}.sock"
  end
  desc "Run rake db:seed"
  task :seed, :roles => :db, :only => { :primary => true } do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle exec rake db:seed"
  end
  desc "Run rake db:migrate"
  task :migrate, :roles => :db, :only => { :primary => true } do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
  end
  desc "Build missing paperclip styles"
  task :build_missing_paperclip_styles, :roles => :web do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle exec rake paperclip:refresh:missing_styles"
  end
end
