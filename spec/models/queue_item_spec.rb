require "spec_helper"

describe QueueItem do
  it {should belong_to(:user)}
  it {should belong_to(:video)}
  it {should validate_numericality_of(:position).only_integer}

  describe "#video_title" do
    it "returns the title of associate video" do
      video = Fabricate(:video, title: "Monk")
      queue_item = Fabricate(:queue_item, video_id: video.id)
      expect(queue_item.video_title).to eq('Monk')
    end
  end

  describe "#rating" do
    it "returns the rating from the review when the review is present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, video: video, user: user, rating: 4)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(4)
    end
    it "returns nil when the review is not present" do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe "#category_name" do
    it "returns the category name when the category is present" do
      category = Fabricate(:category, name: "comedies")
      video = Fabricate(:video, category: category)
      queue_item= Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq("comedies")
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      category = Fabricate(:category, name: "comedies")
      video = Fabricate(:video, category: category)
      queue_item= Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end