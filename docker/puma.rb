require 'fileutils'

FileUtils.mkdir_p('/log')
stdout_redirect '/log/puma-stdout.log', '/log/puma-stdout.log'

if listen_unix = ENV['LISTEN_UNIX']
  bind "unix://#{listen_unix}"
else
  port = ENV['PORT'] || 8080
  bind "tcp://0.0.0.0:#{port}"
end

