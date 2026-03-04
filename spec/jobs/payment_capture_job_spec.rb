# spec/jobs/payment_capture_job_spec.rb
require 'rails_helper'

RSpec.describe PaymentCaptureJob, type: :job do
  include ActiveJob::TestHelper

  let(:order) { create(:order, status: "confirmed") }

  it "queues the job" do
    expect {
      PaymentCaptureJob.perform_later(order.id)
    }.to have_enqueued_job(PaymentCaptureJob).with(order.id)
  end

  it "executes perform" do
    expect_any_instance_of(PaymentCaptureJob).to receive(:perform).with(order.id)
    perform_enqueued_jobs do
      PaymentCaptureJob.perform_later(order.id)
    end
  end
end
