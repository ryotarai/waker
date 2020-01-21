FactoryBot.define do
  factory :topic do
    name { "Infra" }
    kind { "api" }
    escalation_series
  end
end
