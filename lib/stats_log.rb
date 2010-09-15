class StatsLog < ResqueJob
  queue :stats_log

  def self.perform(options)
    if user = User.find_or_create_by_vid(options["vid"])
      attributes = {
        :user_id => user.id,
        :referrer => options["referrer"],
        :user_agent => options["user_agent"],
        :path_name => options["path_name"],
        :query_string => options["query_string"],
        :log_type => options["type"],
        :ab_test_id => options["ab_test_id"]
      }
    
      if (logged_in = options["logged_in"]) || options["has_logged_in"]
        UserLog.create(attributes.merge(:logged_in => logged_in))
      else
        VisitorLog.create(attributes)
      end
    end

    return true    
  end
  
end
