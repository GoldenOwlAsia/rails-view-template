# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  provider               :integer
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe 'validations' do
    let(:user) { build(:user) }

    context 'with valid avatar' do
      it 'is valid when the content type is correct' do
        user.avatar.attach(
          io: Rails.root.join('spec/fixtures/files/image.png').open,
          filename: 'avatar.png',
          content_type: 'image/png'
        )
        expect(user).to be_valid
      end
    end

    context 'with invalid content type' do
      it 'is invalid when the content type is incorrect' do
        user.avatar.attach(
          io: Rails.root.join('spec/fixtures/files/text.txt').open,
          filename: 'avatar.txt',
          content_type: 'text/plain'
        )

        allow(user.avatar.blob).to receive(:content_type).and_return('text/plain')
        expect(user).not_to be_valid

        expect(user.errors[:avatar]&.first).to include('has an invalid content type')
      end
    end

    context 'with large avatar' do
      it 'is invalid when the size exceeds the limit' do
        user.avatar.attach(
          io: Rails.root.join('spec/fixtures/files/image.png').open,
          filename: 'large_image.jpg',
          content_type: 'image/jpeg'
        )
        allow(user.avatar.blob).to receive(:byte_size).and_return(11.megabytes)
        expect(user).not_to be_valid

        expect(user.errors[:avatar]&.first).to include('file size must be less than 10 MB')
      end
    end
  end

  describe 'Devise modules' do
    it 'includes database_authenticatable module' do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it 'includes registerable module' do
      expect(User.devise_modules).to include(:registerable)
    end

    it 'includes recoverable module' do
      expect(User.devise_modules).to include(:recoverable)
    end

    it 'includes rememberable module' do
      expect(User.devise_modules).to include(:rememberable)
    end

    it 'includes validatable module' do
      expect(User.devise_modules).to include(:validatable)
    end

    it 'includes omniauthable module' do
      expect(User.devise_modules).to include(:omniauthable)
    end
  end

  describe 'instance methods' do
    let!(:user) { create(:user) }

    describe '#admin?' do
      it 'returns true if the user has an admin role' do
        user.add_role(:admin)
        expect(user.admin?).to be true
      end

      it 'returns false if the user does not have an admin role' do
        expect(user.admin?).to be false
      end
    end

    describe '#employee?' do
      it 'returns true if the user has an employee role and is not an admin' do
        user.add_role(:employee)
        expect(user.employee?).to be true
      end
    end
  end
end
