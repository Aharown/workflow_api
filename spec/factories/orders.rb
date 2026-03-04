FactoryBot.define do
  factory :order do
    status { 'pending' }
    total_amount { 100.0 }
  end
end
