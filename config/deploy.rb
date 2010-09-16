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

after "deploy:update_code", "deploy:bundle_gems"
after "deploy", "deploy:restart_job_queues"

task :ssh do
  system "ssh -o StrictHostKeyChecking=no root@ec2-67-202-63-244.compute-1.amazonaws.com"
end

namespace :deploy do
  task :restart, :roles => :app do
    #run "touch #{current_path}/tmp/restart.txt"
    run "#{ruby_prefix}/god restart unicorn"
  end

  task :restart_job_queues, :roles => :app do
    if rails_env == 'production'
      run "#{ruby_prefix}/god -p 17166 unmonitor stats_log"
      run "/mnt/app/current/system/scripts/process_killer.sh photo_resize QUIT"
      run "#{ruby_prefix}/god -p 17166 terminate"
    end
    if rails_env == 'production'
      run "#{ruby_prefix}/ruby #{ruby_prefix}/god -p 17166 -c /mnt/app/current/system/god_configs/job_queues.god -l /mnt/log/god.log --no-syslog --log-level error"
    end
  end

  task :bundle_gems, :roles => :app do
    # normally we don't want this, but if the gems cache gets messed up somehow, this should force a refresh:
    #run "rm -rf /mnt/app/current/vendor/cache"

    cmd = [
           "cd #{current_path}",
           "#{ruby_prefix}/bundle install",
          ].join(" && ")
    run cmd
  end
end
