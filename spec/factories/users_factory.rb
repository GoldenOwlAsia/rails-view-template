# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
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
