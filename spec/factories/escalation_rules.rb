# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :escalation_rule do
    name "Default"

    ignore do
      escalations_count 2
    end

    after(:create) do |escalation_rule, evaluator|
      create_list(:escalation, evaluator.escalations_count, escalation_rule: escalation_rule)
    end
  end
end
