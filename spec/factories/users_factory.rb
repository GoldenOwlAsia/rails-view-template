FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@rails.boilerplate.com" }
    password { 'Password123!' }
    confirmed_at { Time.current }
    after(:build) { |user| user.add_role(:employee) }

    trait :admin do
      sequence(:email) { |n| "admin#{n}@rails.boilerplate.com" }
      after(:create) do |user|
        user.remove_role(:employee)
        user.add_role(:admin)
      end
    end
  end
end
