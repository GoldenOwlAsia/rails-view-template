require 'rails_helper'

RSpec.describe Users::FetchUsersQuery, type: :query do
  describe '#call' do
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user, email: 'test2@example.com', created_at: 1.day.ago) }
    let!(:user3) { create(:user, created_at: 2.weeks.ago) }

    context 'when filtering by created_at' do
      it 'returns users created after a specific date' do
        result = described_class.call(date: 1.day.ago)

        expect(result).to include(user1, user2)
        expect(result).not_to include(user3)
      end

      it 'returns all users when date is not provided' do
        result = described_class.call

        expect(result).to include(user1, user2, user3)
      end
    end

    context 'when filtering by email' do
      it 'returns users with the specified email' do
        result = described_class.call(email: 'test2@example.com')

        expect(result).to include(user2)
        expect(result).not_to include(user1, user3)
      end
    end

    context 'when using both filters' do
      it 'returns users matching both conditions' do
        result = described_class.call(date: 1.day.ago, email: user2.email)

        expect(result).to include(user2)
        expect(result).not_to include(user1, user3)
      end
    end

    context 'when ordering results' do
      it 'returns users in the specified order' do
        result = described_class.call(order_by: 'created_at', order_direction: 'desc')

        expect(result).to eq([user1, user2, user3])
      end
    end
  end
end
