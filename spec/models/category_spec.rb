require 'spec_helper'

describe Category do
	# it "saves itself" do
	# 	category = Category.new(name: "comedies")
	# 	category.save
	# 	expect(Category.first).to eq(category)
	# end

	# it "has many videos" do
	# 	comedies = Category.create(name: "comedies")
	# 	south_park = Video.create(title: "South Park", description: "Funny video!", category: comedies)
	# 	futurama = Video.create(title: "Futurama", description: "Space Trval!", category: comedies)
	# 	expect(comedies.videos).to eq([futurama, south_park])
	# end

	# 上面的写法通过shoulda-matchers可以简化为：
	it { should have_many(:videos) }

	describe "#recent_videos" do
		it "return the videos in the reverse chronical order by created at" do
			comedies = Category.create(name: "comedies")
			futurama = Video.create(title: "Futurama", description: "Space Trval!", category: comedies, created_at: 1.day.ago)
  		back_to_future = Video.create(title: "Back to Future", description: 'Time Trval!', category: comedies)
  		expect(comedies.recent_videos).to eq([back_to_future, futurama])
		end
		it "return all the videos if there are less than 6 videos" do
			comedies = Category.create(name: "comedies")
			futurama = Video.create(title: "Futurama", description: "Space Trval!", category: comedies, created_at: 1.day.ago)
  		back_to_future = Video.create(title: "Back to Future", description: 'Time Trval!', category: comedies)
  		expect(comedies.recent_videos.count).to eq(2)
		end
		it "return 6 videos if there are more than 6 videos" do
			comedies = Category.create(name: "comedies")
			7.times {Video.create(title: "foo", description: "bar", category: comedies)}
			expect(comedies.recent_videos.count).to eq(6)
		end
		it "return the most recent 6 videos" do
			comedies = Category.create(name: "comedies")
			6.times {Video.create(title: "foo", description: "bar", category: comedies)}
			tonight_show = Video.create(title: "Tonights show", description: "talk show", category: comedies, created_at: 1.day.ago)
			expect(comedies.recent_videos).not_to include(tonight_show)
		end
		it "return empty array if the category does not have any videos" do
			comedies = Category.create(name: "comedies")
			expect(comedies.videos).to eq([])
		end
	end
end
