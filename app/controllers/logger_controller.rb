class LoggerController < ApplicationController
  
  def log
    Resque.enqueue(StatsLog, params.to_json)
    render :json => {}
  end
  
end
