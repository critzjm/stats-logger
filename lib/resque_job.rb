class ResqueJob
  extend Resque::Plugins::Retry

  def self.perform(*args)
    new.perform(*args)
  ensure
    Rails.logger.flush
  end

  def self.queue(name)
    @queue = name
  end

  def log(msg)
    Rails.logger.info("#{self.class.name}(#{@args.inspect}): #{msg}")
  end  
end
