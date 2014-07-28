require 'securerandom'

ENV['TWILIO_BASIC_AUTH_USER'] ||= SecureRandom.hex
ENV['TWILIO_BASIC_AUTH_PASSWORD'] ||= SecureRandom.hex

Rails.logger.info "twilio basic auth user: #{ENV['TWILIO_BASIC_AUTH_USER']}"
Rails.logger.info "twilio basic auth pass: #{ENV['TWILIO_BASIC_AUTH_PASSWORD']}"
