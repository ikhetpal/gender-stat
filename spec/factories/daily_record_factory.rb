FactoryBot.define do
  factory :daily_record do
    date { Date.current }
    male_count { 100 }
    female_count { 100 }
    male_avg_age { 25 }
    female_avg_age { 25 }
  end
end