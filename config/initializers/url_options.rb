if default_host = ENV['DEFAULT_HOST']
  Rails.application.routes.default_url_options[:host] = default_host
end

if default_protocol = ENV['DEFAULT_PROTOCOL']
  Rails.application.routes.default_url_options[:protocol] = default_protocol
end
