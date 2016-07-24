module StripeWrapper
  class Charge
    def self.create(options={})
      Stripe::Charge.create(
        amount: options[:amount],
        currency: "usd",
        card: options[:card],
        source: "tok_18ahUJJkbwsvv4gejx0pSMLt",
        description: options[:description]
      )
    end
  end
end