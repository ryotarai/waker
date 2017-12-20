Rails.application.config.middleware.use OmniAuth::Builder do
  config = {}
  config[:hd] = ENV['GOOGLE_DOMAIN'] if ENV['GOOGLE_DOMAIN']

  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"],
  config.merge(scope: 'userinfo.profile,userinfo.email,calendar',
               name: 'google_oauth2_with_calendar',
               access_type: 'offline', approval_prompt: 'force', prompt: 'consent')
end
OmniAuth.config.logger = Rails.logger
