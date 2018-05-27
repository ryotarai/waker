namespace = ENV['REDIS_NAMESPACE'] || "waker-#{Rails.env}"
host = ENV['REDIS_HOST'] || 'localhost'
port = ENV['REDIS_PORT'] || 6379

Sidekiq.configure_server do |config|
  config.poll_interval = 5
  config.redis = {url: "redis://#{host}:#{port}", namespace: namespace}
end

Sidekiq.configure_client do |config|
  config.redis = {url: "redis://#{host}:#{port}", namespace: namespace}
end

Sidekiq::Logging.logger = Rails.logger
