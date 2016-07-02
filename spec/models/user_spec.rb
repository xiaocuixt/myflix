require "spec_helper"

describe User do
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC")}

  describe "#queued_video?" do
    it "return true if the user has queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be_truthy
    end
    it "return false if the user has not queued the video" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      user.queued_video?(video).should be_falsey
    end
  end
end