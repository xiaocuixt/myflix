class UsersController < ApplicationController
  before_action :require_user, only: :show
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
      Stripe::Charge.create({
        :amount => 999,
        :currency => "usd",
        :source => params[:stripeToken],
        :description => "Sign UP Charge for #{@user.email}"
      })
      AppMailer.send_welcome_email(@user).deliver
      redirect_to sign_in_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.find_by_token(params[:token])
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end