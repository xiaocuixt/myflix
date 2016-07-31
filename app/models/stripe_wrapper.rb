module StripeWrapper
  class Charge
    def self.create(options={})
      Stripe::Charge.create(
        amount: options[:amount],
        currency: "usd",
        card: options[:card],
        source: options[:source],
        description: options[:description]
      )
    end
  end
end