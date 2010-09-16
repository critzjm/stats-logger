class StatsLog < ResqueJob
  queue :stats_log

  def perform(options)
    options = ActiveSupport::JSON.decode(options)
    log(options)
    
    if options["ab_view_ids"] && (ab_view_ids = options["ab_view_ids"]).any?
      ab_view_ids.uniq.each do |ab_id|
        ab_view_opts = options.dup
        log(ab_view_opts.merge!("type" => "ab_view", "ab_test_id" => ab_id))
      end
    end

    if options["ab_click_ids"] && (ab_view_ids = options["ab_click_ids"]).any?
      ab_click_ids.uniq.each do |ab_id|
        ab_click_opts = options.dup
        log(ab_click_opts.merge!("type" => "ab_click", "ab_test_id" => ab_id))
      end
    end

    return true    
  end
  
  def log(options)
    if user = User.find_or_create_by_vid(options["vid"])
      attributes = {
        :user_id => user.id,
        :ab_test_id => options["ab_test_id"],
        :referrer => options["referrer"],
        :user_agent => options["user_agent"],
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
