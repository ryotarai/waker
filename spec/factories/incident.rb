FactoryBot.define do
  factory :incident do
    id { 1 }
    topic
    subject { "mysql-01 is down" }
    description { "alert" }
  end
end
