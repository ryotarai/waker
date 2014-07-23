# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification_queue do
    notifier nil
    incident nil
    notify_at "2014-07-23 23:46:16"
  end
end
