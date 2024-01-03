require 'json'
require 'stripe'

class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token 
  # before_action :authenticate_user

  def handle_event
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    begin
      event = Stripe::Event.construct_from( JSON.parse(payload, symbolize_names: true) )
    rescue JSON::ParserError => e
      return head :bad_request
    rescue Stripe::SignatureVerificationError => e
      return head :bad_request
    end
    customer_id = params.dig('data', 'object', 'customer')
    price_id = params[:data][:object][:metadata][:price_id]
    handle_payment_success(customer_id, price_id) if event['type'] == 'checkout.session.completed'

    head :ok
  end

  private

  def handle_payment_success(customer_id, price_id)
    GenerateSubscription.create_subscription_and_invoice(customer_id, price_id)
  end
end

