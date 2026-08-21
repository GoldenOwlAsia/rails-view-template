require 'rails_helper'

RSpec.describe Users::Gather do
  describe '.call' do
    it 'returns a relation so callers can keep composing' do
      expect(described_class.call).to be_a(ActiveRecord::Relation)
    end

    it 'returns every user when no filter is given' do
      users = create_list(:user, 2)

      expect(described_class.call).to match_array(users)
    end

    it 'filters by email' do
      match = create(:user, email: 'wanted@example.com')
      create(:user, email: 'other@example.com')

      expect(described_class.call(email: 'wanted@example.com')).to contain_exactly(match)
    end

    it 'ignores a blank email filter' do
      users = create_list(:user, 2)

      expect(described_class.call(email: '')).to match_array(users)
    end

    it 'sorts ascending by default' do
      create(:user, email: 'b@example.com')
      create(:user, email: 'a@example.com')

      expect(described_class.call(sort: 'email').map(&:email))
        .to eq(['a@example.com', 'b@example.com'])
    end

    it 'sorts descending with a - prefix' do
      create(:user, email: 'a@example.com')
      create(:user, email: 'b@example.com')

      expect(described_class.call(sort: '-email').map(&:email))
        .to eq(['b@example.com', 'a@example.com'])
    end

    it 'composes onto a scope the caller passes in' do
      create(:user, email: 'wanted@example.com')
      other = create(:user, email: 'other@example.com')

      expect(described_class.call(User.where(id: other.id), email: 'wanted@example.com'))
        .to be_empty
    end
  end
end
