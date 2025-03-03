require 'rails_helper'

RSpec.describe DateTimeHelper, type: :helper do
  describe '#display_date' do
    let(:datetime) { Date.new(2024, 11, 9) }

    it 'returns formatted date with default format' do
      expect(helper.display_date(datetime)).to eq('09/11/2024')
    end

    it 'returns formatted date with custom format' do
      expect(helper.display_date(datetime, :dmy_dashed)).to eq('2024-11-09')
    end
  end

  describe '#display_time' do
    let(:datetime) { Time.zone.local(2024, 11, 9, 14, 30) }

    it 'returns formatted time with default format' do
      expect(helper.display_time(datetime)).to eq('14:30')
    end

    it 'returns formatted time with custom format' do
      expect(helper.display_time(datetime, :hms24)).to eq('14:30:00')
    end
  end

  describe '#display_datetime' do
    let(:datetime) { DateTime.new(2024, 11, 9, 14, 30) }

    it 'returns formatted datetime with default format' do
      expect(helper.display_datetime(datetime)).to eq('09/11/2024 14:30')
    end

    it 'returns formatted datetime with custom format' do
      expect(helper.display_datetime(datetime, :dmy_hms24)).to eq('09/11/2024 14:30:00')
    end
  end
end
