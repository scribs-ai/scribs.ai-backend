class GenerateSubscription

  def self.create_subscription_and_invoice(subscription_id, customer_id)
    current_user = User.find_by(stripe_customer_id: customer_id)
    update_user(current_user, subscription_id) if subscription_id

    invoice = Stripe::Invoice.create(
      customer: customer_id,
      subscription: subscription_id,
    )

    send_invoice_to_customer(current_user, invoice)

  rescue Stripe::StripeError => e
    render json: { error: e.message }
  end

  private

  def self.send_invoice_to_customer(current_user, invoice)
    UserMailer.subscription_invoice_sent(current_user, invoice).deliver_now
  end

  def self.update_user(current_user, subscription_id)
    current_user.update(subscription: subscription_id)
  end

end