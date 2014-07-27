require 'securerandom'

ENV['TWILIO_BASIC_AUTH_USER'] ||= SecureRandom.hex
ENV['TWILIO_BASIC_AUTH_PASSWORD'] ||= SecureRandom.hex
