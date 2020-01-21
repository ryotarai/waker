FactoryBot.define do
  factory :notifier_provider do
    name { "Logger" }
    kind { :rails_logger }
  end
end
