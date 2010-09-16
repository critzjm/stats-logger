class LoggerController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  
  def log
    params.delete(:action)
    params.delete(:controller)
    params[:user_agent] = params[:user_agent].gsub(/ /, "|") # not sure why, but spaces were breaking popping off the resque queue, so we're replacing them
    Resque.enqueue(StatsLog, params.to_json)
    render :json => {}
  end
  
end