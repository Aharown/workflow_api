require 'rails_helper'

RSpec.describe OrderEvent, type: :model do
  describe "associations" do
    it { should belong_to(:order) }
  end

  describe "validations" do
    it { should validate_presence_of(:event_type) }
    it { should validate_presence_of(:metadata) }
  end

  describe "creation" do
    let(:order) { create(:order, status: "pending") }

    it "is valid with valid attributes" do
      event = OrderEvent.new(
        order: order,
        event_type: "confirm",
        metadata: { from: "pending", to: "confirmed" }
      )

      expect(event).to be_valid
    end

    it "is invalid without an order" do
      event = OrderEvent.new(
        event_type: "confirm",
        metadata: { from: "pending", to: "confirmed" }
      )

      expect(event).not_to be_valid
      expect(event.errors[:order]).to be_present
    end
  end
end
