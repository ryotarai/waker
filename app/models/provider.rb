class Provider < ActiveRecord::Base
  include JsonField

  json_field :details

  has_many :incidents

  validates :name, presence: true
  validates :kind, presence: true
  validates :kind, inclusion: {in: %w!api gmail!}
  validates :escalation_rule, presence: true

  belongs_to :escalation_rule
  
  after_initialize :set_defaults

  def set_defaults
    self.details ||= {}
  end

  def watcher
    begin
      klass = Provider.const_get("#{self.kind.capitalize}Watcher")
    rescue NameError
      return nil
    end

    klass.new(self)
  end

  class BaseWatcher
    attr_reader :provider

    def initialize(provider)
      @provider = provider
    end

    def start
      raise NotImplementedError
    end

    def stop
      raise NotImplementedError
    end
  end

  class GmailWatcher < BaseWatcher
    CHECK_INTERVAL_SEC = 30

    def initialize(*args)
      super
      require 'gmail'
    end

    def start
      @stopped = false

      last_uids = {}
      gmail = Gmail.new(username, password)
      gmail.peek = true

      until @stopped
        gmail.imap.noop

        # check new emails
        labels.each do |label|
          Rails.logger.debug "Checking emails with a label '#{label}'"

          uids = []
          encoded_label = Net::IMAP.encode_utf7(label)
          gmail.mailbox(encoded_label).emails(:unread).each do |message|
            uid = message.uid
            uids << uid

            #binding.pry
            if last_uids[label] && !last_uids[label].include?(uid)
              # new mail
              Rails.logger.debug "New message found: #{message.subject}"
              body = message.body.to_s.force_encoding('UTF-8')
              Incident.create!(
                description: message.subject,
                provider: provider,
                details: {'body' => body},
              )
              Rails.logger.debug "New incident created"
            end
          end
          last_uids[label] = uids
        end

        sleep CHECK_INTERVAL_SEC
      end

      gmail.logout
    end

    def stop
      @stopped = true
    end

    private
    def labels
      @provider.details['labels']
    end

    def username
      @provider.details['username']
    end

    def password
      @provider.details['password'] || password_from_env
    end

    def password_from_env
      return nil unless ENV['PROVIDER_GMAIL_PASSWORD']

      result = nil
      ENV['PROVIDER_GMAIL_PASSWORD'].split(',').each do |pair|
        user, password = pair.split(':')
        if username == user
          result = password
          break
        end
      end

      result
    end
  end
end
