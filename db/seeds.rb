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

notifier = Notifier.find_or_create_by!(user: user, type: 'mail') do |notifier|
  notifier.notify_after = 0
  notifier.details = {'to' => mail_to}
end

escalation = Escalation.find_or_create_by!(name: 'Default') do |escalation|
  escalation.rules = []
  escalation.rules << {'user' => user.id, 'at' => 0}
  escalation.rules << {'user' => user.id, 'at' => 60 * 5}
end

Provider.find_or_create_by!(name: 'Default') do |provider|
  provider.type = 'api'
  provider.details = {}
  provider.escalation = escalation
end


