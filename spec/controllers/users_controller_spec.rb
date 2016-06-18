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
end