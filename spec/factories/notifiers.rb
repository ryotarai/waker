# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notifier do
    name 'Default'
    kind 'mail'
    details({'key' => 'value'})
    notify_after 60
    user
  end
end
