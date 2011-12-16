require "bundler/capistrano"
set :application, "lms"
set :repository,  "git@github.com:faraazkhan/canvas.git"

set :scm, "git" 
set :scm_passphrase, "faraazkhan"
set :branch, "master"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "~/bitnami/rationalizeit/lms.rationalizeitconsulting.com/current/var/www/lms.rationalizeitconsulting.com"
set :location, "ec2-107-22-40-195.compute-1.amazonaws.com"

role :web, location, :primary => true 
role :app, location, :primary => true 
role :db,  location, :primary => true
#role :db,  "your slave db-server here"
set :user, "bitnami"
set :ssh_options, {:forward_agent => true}
default_run_options[:pty] = true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end

# task :bundle do
 #   run "/usr/lib/ruby/gems/1.8/bin//bundle install --gemfile #{current_path}/Gemfile --path /var/www/applications/#{rails_env}.blackmanjones.com/shared/vendor_bundle --deployment --quiet --without development test cucumber"
  #end
