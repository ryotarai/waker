require 'fileutils'

listen_unix = ENV['LISTEN_UNIX']

if listen_unix
  bind "unix://#{listen_unix}"
end

port = ENV['PORT'] || 8080
bind "tcp://0.0.0.0:#{port}"

