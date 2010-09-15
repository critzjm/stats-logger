class Log

  def self.perform(options)
    attributes = {
      :referrer => options["referrer"],
      :user_agent => options["user_agent"],
      :path_name => options["path_name"],
      :query_string => options["query_string"],
      :log_type => options["type"],
      :ab_test_id => options["ab_test_id"]
    }
    
    if options["logged_in"] || options["has_logged_in"]
      UserLog.create(attributes.merge(:logged_in => options["logged_in"]))
    else
      VisitorLog.create(attributes)
    end

    return true    
  end
  
end
