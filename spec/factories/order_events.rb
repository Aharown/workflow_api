FactoryBot.define do
  factory :order_event do
    order
    event_type { 'confirm' }
    metadata { {} }
  end
end
