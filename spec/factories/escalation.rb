FactoryBot.define do
  factory :escalation do
    association :escalate_to, factory: :user
    escalate_after_sec { 60 }
    escalation_series
  end
end
