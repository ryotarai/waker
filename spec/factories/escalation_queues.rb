# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :escalation_queue do
    incident nil
    escalation nil
    escalate_at "2014-07-23 23:26:55"
  end
end
