FactoryBot.define do
  factory :notifier do
    user
    association :provider, factory: :notifier_provider
    notify_after_sec { 60 }
  end
end
