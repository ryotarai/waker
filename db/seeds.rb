# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.find_or_create_by(name: 'Philip Sparke')
user.notifiers.find_or_create_by(kind: :rails_logger, notify_after_sec: 10)
series = EscalationSeries.find_or_create_by(name: 'Default')
series.escalations.find_or_create_by(escalate_to: user, escalate_after_sec: 10)
series.topics.find_or_create_by(name: 'Default', kind: :api)
