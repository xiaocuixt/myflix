require "spec_helper"

describe User do
  it { should have_many(:queue_items).order(:position) }

  describe "#queued_video?" do
    it "return true if the user has queued the video" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: user, video: video)
      user.queued_video?(video).should be_true
    end
    it "return false if the user has not queued the video" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      user.queued_video?(video).should be_false
    end
  end
end