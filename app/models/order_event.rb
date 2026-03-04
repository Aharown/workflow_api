class OrderEvent < ApplicationRecord
  belongs_to :order

  validates :event_type, presence: true
  validates :metadata, presence: true
end
