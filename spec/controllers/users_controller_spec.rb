require "spec_helper"

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "with valid user" do
      before {post :create, user: Fabricate.attributes_for(:user)}
      it "creates the new user" do
        expect(User.count).to eq(1)
      end
      it "redirects to the sign in page" do
        expect(response).to redirect_to sign_in_path
      end
    end

    context "email sending" do
      after { ActionMailer::Base.deliveries.clear }
      it "sends out the email with valid inputs" do
        post :create, user: {email: "xiaocui@test.com", password: "password", full_name: "xiaocui"}
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq(["xiaocui@test.com"])
      end
      it "sends out email contains the user's name with valid inputs" do
        post :create, user: {email: "xiaocui@test.com", password: "password", full_name: "xiaocui"}
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include("xiaocui")
      end
      it "doesn't send email with unvalid inputs" do
        post :create, user: {email: "xiaocui@test.com", full_name: "xiaocui"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "with invalid user" do
      before { post :create, user: {password: "password", full_name: "xiaocui"} }
      it "does not create new user" do
        expect(User.count).to eq(0)
      end
      it "render new template" do
        expect(response).to render_template :new
      end
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end

  describe "GET show" do
    it_behaves_like "require_sign_in" do
      let(:action) {get :show, id: 3}
    end
    it "set @user variable" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end
end