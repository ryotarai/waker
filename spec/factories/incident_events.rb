FactoryBot.define do
  factory :incident_event do
    incident_id { 1 }
    kind { :opened }
  end
end
