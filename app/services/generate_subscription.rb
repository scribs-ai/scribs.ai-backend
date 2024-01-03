class GenerateSubscription

  def self.create_subscription_and_invoice(customer_id, price_id)
    current_user = User.find_by(stripe_customer_id: customer_id)
    subscription = create_stripe_subscription(customer_id, price_id)
    update_user(current_user, subscription) if subscription
    

    invoice = Stripe::Invoice.create(
      customer: customer_id,
      subscription: subscription.id,
    )

    send_invoice_to_customer(current_user, invoice)

  rescue Stripe::StripeError => e
    render json: { error: e.message }
  end

  private

  def self.create_stripe_subscription(customer_id, price_id)
    Stripe::Subscription.create(
      customer: customer_id,
      items: [{ price: price_id }],
      payment_behavior: 'default_incomplete',
      payment_settings: {
        payment_method_types: ['card']
      },
      expand: ['latest_invoice.payment_intent']
    )
  end

  def self.send_invoice_to_customer(current_user, invoice)
    UserMailer.subscription_invoice_sent(current_user, invoice).deliver_now
  end

  def self.update_user(current_user, subscription)
    current_user.update(subscription: subscription.id)
  end

end