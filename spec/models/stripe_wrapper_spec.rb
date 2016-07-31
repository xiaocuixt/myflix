require "spec_helper"

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 7,
            :exp_year => 2017,
            :cvc => "314"
          }
        )

        response = StripeWrapper::Charge.create(
          :amount => 999,
          :currency => "usd",
          :source => token,
          :description => "Charge for test@example.com"
        )

        expect(response.amount).to eq(999)
        expect(response.currency).to eq('usd')
      end
    end
  end
end