# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :incident do
    description 'content'
    provider
    details({'key' => 'value'})
  end
end
