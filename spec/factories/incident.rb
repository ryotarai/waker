FactoryBot.define do
  factory :incident do
    topic
    subject { "mysql-01 is down" }
    description { "alert" }
  end
end
