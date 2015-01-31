if default_host = ENV['DEFAULT_HOST']
  Rails.application.routes.default_url_options[:host] = default_host
end
