# god monitor for job queues
#-- god -p 17166 -c /mnt/app/current/system/job_queues.god -l /mnt/log/god.log --no-syslog --log-level error

rails_env = ENV['RAILS_ENV'] || 'production'
rails_root = ENV['RAILS_ROOT'] || "/mnt/app/current"

God.watch do |w|
  sleep 1
  w.name = "stats_log"
  w.interval = 1.minutes
  w.env = {"RAILS_ENV" => "#{rails_env}"}
  w.start = "cd /mnt/app/current && QUEUES=stats_log /usr/local/ruby-enterprise/bin/ruby /usr/local/ruby-enterprise/bin/rake environment resque:work > /dev/null"
  w.stop = "/mnt/app/current/system/scripts/process_killer.sh 'stats_log' QUIT"

  w.start_if do |start|
    start.condition(:process_running) do |c| 
      c.running = false 
    end 
  end 
end
