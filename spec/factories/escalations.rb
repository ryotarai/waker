# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :escalation do
    association :escalate_to, factory: :user
    escalate_after 60
    escalation_rule
  end
end
