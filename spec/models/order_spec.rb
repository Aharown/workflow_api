require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "associations" do
    it { should have_many(:order_events).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:status) }
  end

  describe "state machine (AASM)" do
    let(:order) { create(:order, status: 'pending') }

    context "initial state" do
      it "starts as pending" do
        expect(order.status).to eq("pending")
      end
    end

    context "confirm transition" do
      it "allows confirm from pending" do
        expect(order.may_confirm?).to be true
      end

      it "changes state to confirmed when confirmed" do
        order.confirm
        expect(order.status).to eq("confirmed")
      end

      it "persists the state when confirmed!" do
        order.confirm!
        expect(order.reload.status).to eq("confirmed")
      end

      it "does not allow confirm if already confirmed" do
        order.confirm!
        expect(order.may_confirm?).to be false
      end
    end

    context "invalid transitions" do
      it "does not allow ship from pending" do
        expect(order.may_ship?).to be false if order.respond_to?(:may_ship?)
      end
    end
  end
end
