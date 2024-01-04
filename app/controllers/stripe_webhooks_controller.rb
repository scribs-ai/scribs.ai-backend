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
    current_user = User.find_by(stripe_customer_id: customer_id)
  
    checkout_session_id = event[:data][:object][:id]
    checkout_session = Stripe::Checkout::Session.retrieve(checkout_session_id)
    subscription_id = checkout_session.subscription
    handle_payment_success(subscription_id, customer_id) if event['type'] == 'checkout.session.completed'

    head :ok
  end

  private

  def handle_payment_success(subscription_id, customer_id)
    GenerateSubscription.create_subscription_and_invoice(subscription_id, customer_id)
  end
end

