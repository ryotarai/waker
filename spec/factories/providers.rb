# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :provider do
    name 'Default'
    kind 'api'
    details({'key' => 'value'})
    escalation_rule
  end
end
