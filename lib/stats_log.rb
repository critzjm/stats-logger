class StatsLog < ResqueJob
  queue :stats_log

  def perform(options)
    options = JSON.parse(options)
    log(options)

    return true    
  end
  
  def log(options)
    if user = User.find_or_create_by_vid(options["vid"])
      attributes = {
        :user_id => user.id,
        :ab_test_id => options["ab_test_id"],
        :referrer => options["referrer"],
        :user_agent => options["user_agent"].gsub(/\|/, " "), # not sure why, but spaces were breaking popping off the resque queue, so we're replacing them
        :path_name => options["path_name"],
        :query_string => options["query_string"],
        :log_type => options["type"]
      }
      if (logged_in = options["logged_in"]) == "true" || options["has_logged_in"] == "true"
        UserLog.create(attributes.merge(:logged_in => logged_in))
      else
        VisitorLog.create(attributes)
      end
    end
  end

end
