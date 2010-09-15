set :application, "stats_logger"
set :repository,  "git@github.com:critzjm/stats-logger.git"

set :scm, :git
set :deploy_to, "/mnt/app"
set :branch, "master"

set :user, "root"
set :use_sudo, false

set :ruby_prefix, "/usr/local/ruby-enterprise/bin"

role :web, "ec2-67-202-63-244.compute-1.amazonaws.com"
role :app, "ec2-67-202-63-244.compute-1.amazonaws.com"
role :db,  "ec2-67-202-63-244.compute-1.amazonaws.com", :primary => true
