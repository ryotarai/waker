# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_notifier do
    kind "MyString"
    details_json "MyText"
  end
end
