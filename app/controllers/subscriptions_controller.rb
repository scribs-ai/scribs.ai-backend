class SubscriptionsController < ApplicationController
  before_action :authenticate_user
  
  def create_subscription_and_invoice
    customer = create_stripe_customer
    product = create_stripe_product
    plan = create_stripe_plan(product)
    subscription = create_stripe_subscription(customer, plan)
    
    current_user.update(stripe_customer_id: customer.id) if customer
    update_user(subscription) if subscription
    
    customer_id = customer.id
    plan_id = plan.id

    invoice = Stripe::Invoice.create(
      customer: customer_id,
      subscription: subscription.id,
    )

    send_invoice_to_customer(customer_id, invoice)

    # You can return any relevant information in the API response
    render json: {
      subscription: subscription,
      invoice: invoice,
      message: 'Subscription and invoice created successfully.'
    }
  rescue Stripe::StripeError => e
    render json: { error: e.message }
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

  private

  def send_invoice_to_customer(customer_id, invoice)
    UserMailer.subscription_invoice_sent(current_user, invoice).deliver_now
  end
  
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
    current_subscription = Stripe::Subscription.retrieve(current_user.subscription, { stripe_account: 'acct_1ORswSSAw4lwtIyg' })
    return { message: 'No subscription found' } unless current_subscription
    
    canceled_subscription = Stripe::Subscription.cancel(current_subscription.id)
    current_user.update(subscription: nil)
    { message: 'Subscription cancelled successfully' }
  end
  

  def create_stripe_customer
    Stripe::Customer.create(email: current_user.email)
  end

  def create_stripe_product
    Stripe::Product.create(name: 'gold plan')
  end

  def create_stripe_plan(product)
    Stripe::Plan.create(
      amount: 1200,
      currency: 'usd',
      interval: 'month',
      product: product.id
    )
  end

  def create_stripe_subscription(customer, plan)
    Stripe::Subscription.create(
      customer: customer.id,
      items: [{ price: plan.id }],
      payment_behavior: 'default_incomplete',
      payment_settings: {
        payment_method_types: ['card']
      },
      expand: ['latest_invoice.payment_intent']
    )
  end

  def update_user(subscription)
    current_user.update(subscription: subscription.id)
  end
end