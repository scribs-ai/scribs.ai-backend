class SubscriptionsController < ApplicationController
  before_action :authenticate_user

  def create_customer_and_intent
    customer = create_stripe_customer
    price_id = create_stripe_price(params[:plan])

    customer_checkout_session = create_checkout_session(price_id, customer.id)
    render json: {client_secret: customer_checkout_session.url}, status: :ok
  end


  def upgrade
    message = if current_user.subscription.nil?
      { message: 'No subscription found' }
    else
      current_subscription = Stripe::Subscription.retrieve(current_user.subscription, { stripe_account: Rails.application.credentials.dig(:stripe, :account_id) })
      upgrade_subscription(current_subscription)
    end
    
    render json: message, status: :ok
  end

  def cancel
    message = if current_user.subscription.nil?
                { message: 'No subscription found' }
              else
                cancel_subscription
              end
              
              render json: message, status: :ok
  end

  def refunds
    response = Stripe::Refund.list(current_user.stripe_customer_id, {limit: 3})
    render json: {refunds: response}, status: :ok
  end

  def transaction_by_user
    response = Stripe::Customer.list_balance_transactions(current_user.stripe_customer_id, {limit: 3})
    render json: {transaction: response}, status: :ok
  end

  private
  
  def upgrade_subscription(current_subscription)
    message = { message: 'Subscription not found' } 
    return message if current_subscription.nil?
    
    new_product = Stripe::Product.create(name: 'silver plan')
    
    new_plan = Stripe::Plan.create(
      amount: 1200,
      currency: 'usd',
      interval: 'month',
      product: new_product.id
    )
    
    updated_subscription = Stripe::Subscription.update(
      current_subscription.id,
      # items: [{ id: current_subscription.items.data[0].id, price: new_plan.id }],
      metadata: { order_id: '6735' }
    )
    
    update_user(updated_subscription)
    { message: 'Subscription updated successfully' }
  end
  
      
  def cancel_subscription
    current_subscription = Stripe::Subscription.retrieve(current_user.subscription,  { stripe_account: Rails.application.credentials.dig(:stripe, :account_id) })
    return { message: 'No subscription found' } unless current_subscription
    
    canceled_subscription = Stripe::Subscription.cancel(current_subscription.id)
    current_user.update(subscription: nil)
    { message: 'Subscription cancelled successfully' }
  end
  

  def create_stripe_customer
    return current_user.stripe_customer_id if current_user.stripe_customer_id
    customer = Stripe::Customer.create(email: current_user.email)
    current_user.update(stripe_customer_id: customer.id)
    customer
  end

  def create_stripe_price(price)
    case price
    when 'A'
      Price.first
    when 'B'
      Price.second
    when 'C'
      Price.third
    else
      # Handle the case when the plan is not recognized
      raise ArgumentError, "Invalid plan: #{plan}"
    end
  end

  def create_checkout_session(price_id, customer_id)
    checkout_session = Stripe::Checkout::Session.create({
    success_url: 'https://example.com/success',
    line_items: [
      {
        price: price.id,
        quantity: 1,
      },
    ],
    mode: 'subscription',
    customer: customer_id,
    metadata: {
    price_id: price_id
  },
  })
  end
end