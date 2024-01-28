class DailyRecordsController < ApplicationController
  before_action :set_daily_records, only: %i(index)

  def index
    @liquid_template = Liquid::Template.parse(File.read(Rails.root.join('app/views/daily_records/index.liquid')))
  end

  private

  def set_daily_records
    daily_records = DailyRecord.all

    @daily_records = daily_records.map do |daily_record|
      {
        'date' => daily_record.date.strftime("%d %B %Y"),
        'male_count' => daily_record.male_count,
        'female_count' => daily_record.female_count,
        'male_avg_age' => daily_record.male_avg_age,
        'female_avg_age' => daily_record.female_avg_age
      }
    end
  end
end
