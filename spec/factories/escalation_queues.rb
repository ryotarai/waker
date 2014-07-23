# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :escalation_queue do
    incident
    escalation
    escalate_at Time.now
  end
end
