config_for = lambda do |file|
  YAML.load(File.read(File.join(Rails.root, 'config', file)))[Rails.env]
end

REDIS_CONFIG = config_for.call('redis.yml')
REDIS = Redis.new(:host => REDIS_CONFIG['server'])
Resque.redis = REDIS
