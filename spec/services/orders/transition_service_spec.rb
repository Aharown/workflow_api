require 'rails_helper'

RSpec.describe Orders::TransitionService, type: :service do
  include ActiveJob::TestHelper

  let(:order) { create(:order, status: "pending") }

  describe ".call" do
    context "when transition is allowed" do
      it "changes the order state" do
        described_class.call(order: order, event: "confirm")

        expect(order.reload.status).to eq("confirmed")
      end

      it "creates an OrderEvent" do
        expect {
          described_class.call(order: order, event: "confirm")
        }.to change(OrderEvent, :count).by(1)
      end

      it "stores correct metadata" do
        described_class.call(order: order, event: "confirm")

        event = OrderEvent.last

        expect(event.event_type).to eq("confirm")
        expect(event.metadata["from"]).to eq("pending")
        expect(event.metadata["to"]).to eq("confirmed")
      end

      it "enqueues PaymentCaptureJob" do
        expect {
          described_class.call(order: order, event: "confirm")
        }.to have_enqueued_job(PaymentCaptureJob).with(order.id)
      end
    end

    context "when transition is not allowed" do
      before { order.update!(status: "confirmed") }

      it "does not change state" do
        described_class.call(order: order, event: "confirm")

        expect(order.reload.status).to eq("confirmed")
      end

      it "does not create an OrderEvent" do
        expect {
          described_class.call(order: order, event: "confirm")
        }.not_to change(OrderEvent, :count)
      end

      it "does not enqueue a job" do
        expect {
          described_class.call(order: order, event: "confirm")
        }.not_to have_enqueued_job(PaymentCaptureJob)
      end
    end
  end
end
