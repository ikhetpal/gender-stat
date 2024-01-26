require 'rails_helper'
RSpec.describe DailyGenderStatJob, type: :job do
  before do
    allow(RedisUtility).to receive(:fetch_data).with('male_count').and_return(50)
    allow(RedisUtility).to receive(:fetch_data).with('female_count').and_return(50)
    allow(RedisUtility).to receive(:reset_count).and_return('OK')
  end

  describe '#initialize' do
    it 'sets daily_record' do
      daily_record = FactoryBot.create(:daily_record, date: Date.yesterday)
      job = described_class.new
      expect(job.daily_record).to eq(daily_record)
    end

    it 'sets redis_male_count' do
      job = described_class.new
      expect(job.redis_male_count).to eq(50)
    end

    it 'sets redis_female_count' do
      job = described_class.new
      expect(job.redis_female_count).to eq(50)
    end
  end

  describe '#perform' do
    it 'returns from the call if no daily record is found' do
      expect(described_class.new.perform).to eq(nil)
    end

    it 'updates daily record with male and female count and resets redis data' do
      daily_record = FactoryBot.create(:daily_record, date: Date.yesterday, male_count: nil, female_count: nil, male_avg_age: nil, female_avg_age: nil)
      expect(described_class.new.perform).to eq('OK')
      expect(daily_record.reload.male_count).to eq(50)
      expect(daily_record.reload.female_count).to eq(50)
    end
  end
end
