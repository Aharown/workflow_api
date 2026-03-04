# spec/requests/orders_spec.rb
require 'rails_helper'

RSpec.describe "Orders API", type: :request do
  let!(:order) { create(:order, status: 'pending') }
  let(:headers) { { "Content-Type" => "application/json" } }

  describe "POST /orders/:id/transition" do
    before { clear_enqueued_jobs }

    context "when confirming an order" do
      it "changes the state to confirmed" do
        post "/orders/#{order.id}/transition", params: { event: 'confirm' }.to_json, headers: headers
        expect(response).to have_http_status(:ok)
        order.reload
        expect(order.status).to eq('confirmed')
      end

      it "creates an OrderEvent" do
        expect {
          post "/orders/#{order.id}/transition", params: { event: 'confirm' }.to_json, headers: headers
        }.to change(OrderEvent, :count).by(1)

        event = OrderEvent.last
        expect(event.order).to eq(order)
        expect(event.event_type).to eq('confirm')
      end

      it "triggers a background job" do
        expect {
          post "/orders/#{order.id}/transition", params: { event: 'confirm' }.to_json, headers: headers
        }.to have_enqueued_job(PaymentCaptureJob).with(order.id)
      end

      it "does nothing when confirming twice" do
        post "/orders/#{order.id}/transition", params: { event: 'confirm' }.to_json, headers: headers
        expect {
          post "/orders/#{order.id}/transition", params: { event: 'confirm' }.to_json, headers: headers
        }.not_to change { order.reload.status }
      end
    end

    context "when event does not exist" do
      it "returns an error" do
        post "/orders/#{order.id}/transition",
             params: { event: "invalid_event" },
             as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when transition is not allowed" do
      before { order.update!(status: "confirmed") }

      it "does not change state" do
        post "/orders/#{order.id}/transition",
             params: { event: "confirm" },
             as: :json

        expect(order.reload.status).to eq("confirmed")
      end

      it "does not create an OrderEvent" do
        expect {
          post "/orders/#{order.id}/transition",
               params: { event: "confirm" },
               as: :json
        }.not_to change(OrderEvent, :count)
      end
    end

    context "when order does not exist" do
      it "returns 404" do
        post "/orders/999999/transition",
             params: { event: "confirm" },
             as: :json

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when event param is missing" do
      it "returns 400 or 422" do
        post "/orders/#{order.id}/transition",
             params: {},
             as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
