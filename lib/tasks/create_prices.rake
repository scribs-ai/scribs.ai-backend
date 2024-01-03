namespace :stripe do
  desc 'Create Stripe prices and store them in the prices table'

  task create_prices: :environment do
    product_1 = Stripe::Product.create(name: 'Silver plan')
    product_2 = Stripe::Product.create(name: 'Gold plan')
    product_3 = Stripe::Product.create(name: 'Platinum plan')

    price_1 = Stripe::Price.create({
      currency: 'usd',
      unit_amount: 1000,
      recurring: {interval: 'month'},
      product: product_1.id,
    })

    price_2 = Stripe::Price.create(
      unit_amount: 1000,
      currency: 'usd',
      recurring: {interval: 'month'},
      product: product_2.id
    )

    price_3 = Stripe::Price.create(
      unit_amount: 1200,
      currency: 'usd',
      recurring: {interval: 'month'},
      product: product_3.id
    )

    # Store prices in the database
    Price.create(stripe_price_id: price_1.id)
    Price.create(stripe_price_id: price_2.id)
    Price.create(stripe_price_id: price_3.id)

    puts 'Stripe prices created and stored in the prices table.'
  end
end
