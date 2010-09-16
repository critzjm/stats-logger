class LoggerController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  
  def log
    if params[:type]
      params.delete(:action)
      params.delete(:controller)
      params[:user_agent] = params[:user_agent].gsub(/ /, "|") if params[:user_agent] # not sure why, but spaces were breaking popping off the resque queue, so we're replacing them
      Rails.logger.info "==\n#{params.inspect}\n=="
      Resque.enqueue(StatsLog, params.to_json)
    end
    render :json => {}
  end
  
end
