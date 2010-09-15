# god monitor for job queues

rails_env = ENV['RAILS_ENV'] || 'production'
rails_root = ENV['RAILS_ROOT'] || "/mnt/app/current"
1.times do |i|
  God.watch do |w|
    sleep 1
    w.group = 'stats_logger'
    w.name = "stats_logger_#{i}"
    w.interval = 1.minutes
    w.env = {"RAILS_ENV" => "#{rails_env}"}
    w.start = "cd /mnt/app/current && RAILS_ENV=production QUEUES=stats_logger /usr/local/ruby-enterprise/bin/ruby /usr/local/ruby-enterprise/bin/rake environment resque:work > /dev/null"
    w.stop = "/mnt/app/current/system/scripts/process_killer.sh 'stats_logger' QUIT"

    w.start_if do |start|
      start.condition(:process_running) do |c| 
        c.running = false 
      end 
    end 
  end
end
