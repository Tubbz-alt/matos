set :application, "MATOS"
set :scm, :git
set :repository,  "git://github.com/asascience-open/matos.git"
set :user, "matos"
set :use_sudo, false
set :branch, "master"
set :keep_releases, 5
set :deploy_via, :remote_cache
# Use the version of ruby we are using locally
set :rvm_ruby_string, :local

task :production do
  set :deploy_to, "/var/www/applications/matos/production"
  set :rails_env, "production"
  set :domain, "matos.asascience.com"
  role :web, "matos.asascience.com"
  role :db, "matos.asascience.com", :primary => true
end

task :staging do
  set :deploy_to, "/var/www/applications/matos/staging"
  set :rails_env, "staging"
  set :domain, "matos.asascience.com"
  role :web, "matos.asascience.com"
  role :db, "matos.asascience.com", :primary => true
end

before "deploy:assets:precompile", "deploy:bundle_install"
after  "deploy:update_code","deploy:migrate"
#after  "deploy:update_code","deploy:build_missing_paperclip_styles"
after  "deploy:update", "deploy:cleanup"

namespace :deploy do
  task :bundle_install, :roles => :web do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle install"
  end
  task :bundle_update, :roles => :web do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle update"
  end
  task :restart, :roles => :web do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle exec thin restart -e #{rails_env} -s 2 -d --socket /tmp/thin.#{rails_env}.sock"
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle exec script/delayed_job stop"
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle exec script/delayed_job start"
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

  # Don't precompile assets if nothing has changed
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      begin
        from = source.next_revision(current_revision)
      rescue
        err_no = true
      end
      if err_no || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end

end

require "rvm/capistrano"