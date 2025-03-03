require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'constants' do
    it 'defines the correct role names' do
      expect(Role::NAMES).to eq(%w[super_admin admin employee].freeze)
    end
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:users).join_table(:users_roles) }
    it { should belong_to(:resource).optional }
  end

  describe 'validations' do
    it { should validate_inclusion_of(:name).in_array(Role::NAMES) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_inclusion_of(:resource_type).in_array(Rolify.resource_types).allow_nil }
  end
end
