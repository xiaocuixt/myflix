require "spec_helper"

describe RelationshipsController do
  describe "GET index" do
    it "set @relationships to the current user's following relationships" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: bob)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end
    it_behaves_like "require_sign_in" do
      let(:action) {get :index}
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "require_sign_in" do
      let(:action) {delete :destroy, id: 4}
    end
    it "redirects to people path" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower_id: alice.id, leader_id: bob.id)
      delete :destroy, id: relationship.id
      expect(response).to redirect_to people_path
    end
    it "deletes the relationship if the current user is the follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower_id: alice.id, leader_id: bob.id)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end
    it "does not delete the relationship if the current user is not follower" do
      alice = Fabricate(:user)
      set_current_user(alice)
      kevin = Fabricate(:user)
      bob = Fabricate(:user)
      relationship = Fabricate(:relationship, follower_id: kevin.id, leader_id: bob.id)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(1)
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) {post :create, leader_id: 4}
    end
    it "redirects to people path" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(response).to redirect_to people_path
    end

    it "create a relationship that the current user follow the leader" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      post :create, leader_id: bob.id
      expect(alice.following_relationships.first.leader).to eq(bob)
    end

    it "does not create a relationship that the current user has followed the leader" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      Fabricate(:relationship, follower_id: alice.id, leader_id: bob.id)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(1)
    end
    it "does not allow follow slef" do
      alice = Fabricate(:user)
      set_current_user(alice)
      post :create, leader_id: alice.id
      expect(Relationship.count).to eq(0)
    end
  end
end