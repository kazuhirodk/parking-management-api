FactoryBot.define do
  factory :parking do
    entrance_date { Time.current }
    status { 'initiated' }
    association :vehicle
  end
end
