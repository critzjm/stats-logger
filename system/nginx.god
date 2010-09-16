God.watch do |w|
  w.group = 'nginx'
  w.name = 'nginx-stats-log'
  w.interval = 5.seconds
  w.start = "ulimit -n 65536 && /usr/local/nginx/sbin/nginx -c /mnt/app/current/system/nginx.conf"
  w.stop = "kill `cat /var/run/nginx.pid`"
  w.restart = "kill `cat /var/run/nginx.pid` && ulimit -n 65536 && /usr/local/nginx/sbin/nginx -c /mnt/app/current/system/nginx.conf"
  w.restart_grace = 10.seconds
  w.pid_file = "/var/run/nginx.pid"

  w.behavior(:clean_pid_file)

  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.running = false
    end
  end
end

