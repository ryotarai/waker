# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shift do
    name "Default"
    ical "http://example.com/example.ical"
  end
end
