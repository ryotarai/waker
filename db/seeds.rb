# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

raise 'Please set MAIL_TO' unless ENV['MAIL_TO']
mail_to = ENV['MAIL_TO']

user = User.find_or_create_by!(name: 'Bob')

notifier = Notifier.find_or_create_by!(name: 'Default') do |notifier|
  notifier.user = user
  notifier.kind = 'mail'
  notifier.notify_after = 0
  notifier.details = {'to' => mail_to}
end

escalation_rule = EscalationRule.find_or_create_by!(name: 'Default') do |escalation_rule|
  escalation_rule.escalations << Escalation.new(escalate_to: user, escalate_after: 10)
  escalation_rule.escalations << Escalation.new(escalate_to: user, escalate_after: 60)
end

Provider.find_or_create_by!(name: 'Default') do |provider|
  provider.kind = 'api'
  provider.details = {}
  provider.escalation_rule = escalation_rule
end


