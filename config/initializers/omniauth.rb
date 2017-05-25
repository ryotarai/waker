Rails.application.config.middleware.use OmniAuth::Builder do
  config = {}
  config[:hd] = ENV['GOOGLE_DOMAIN'] if ENV['GOOGLE_DOMAIN']

  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"],
    config.merge(scope: 'profile,userinfo.email,calendar', prompt: 'consent', name: 'google_oauth2_with_calendar')
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"], config
end
OmniAuth.config.logger = Rails.logger
