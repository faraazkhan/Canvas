require "bundler/capistrano"
require "rvm/capistrano" 
before "deploy", "deploy:create_gemset"
set :rvm_ruby_string, 'ree@canvas'
set :application, "lms"
set :repository,  "git@github.com:faraazkhan/canvas.git"

set :scm, "git" 
set :scm_passphrase, "faraazkhan"
set :branch, "master"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "/var/www/applications/rationalizeitconsulting.com"
set :location, "107.21.100.207"

role :web, location
role :app, location
role :db,  location, :primary => true
#role :db,  "your slave db-server here"
set :user, "root"
set :use_sudo, false
set :ssh_options, {:forward_agent => true, :keys => [File.join(ENV["HOME"], ".ssh", "rationalizeit.pem")]}
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

 namespace :deploy do
  desc "Create the gemset"
  task :create_gemset do
    run "rvm #{rvm_ruby_string} --create"
  end
 end

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end
after "deploy:update_code", "rvm:trust_rvmrc"
 


# task :bundle do
 #   run "/usr/lib/ruby/gems/1.8/bin//bundle install --gemfile #{current_path}/Gemfile --path /var/www/applications/#{rails_env}.blackmanjones.com/shared/vendor_bundle --deployment --quiet --without development test cucumber"
  #end
