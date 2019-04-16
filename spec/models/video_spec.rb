require 'spec_helper'

describe Video do
  describe ".search", :elasticsearch do
    # 准备测试数据
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title, description and reviews" do
      it 'returns an an empty array for no match with reviews option' do
        star_wars = Fabricate(:video, title: "Star Wars")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, content: "such a star movie!")
        refresh_index

        expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
      end

      it 'returns an array of many videos with relevance title > description > review' do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "the sun is a star!")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, content: "such a star movie!")
        refresh_index

        expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
      end
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end
    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index

        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
      end
    end
  end
  # it "saves itself" do
  # 	video = Video.new(title: "monk", description: "a greate video")
  # 	video.save
  # 	expect(Video.first).to eq(video)
  # end

  # it "belongs to category" do
  # 	dramas = Category.new(name: "dramas")
  # 	monk = Video.create(title: "monk", description: "a great video", category: dramas)
  #   expect(monk.category).to eq(dramas)
  # end

  # it "does not save a video without a title" do
  # 	video = Video.create(description: "this is a greate video")
  # 	expect(Video.count).to eq(0)
  # end

  # it "does not save a video without a description" do
  # 	video = Video.create(title: "monk")
  # 	expect(Video.count).to eq(0)
  # end

  # 上面的写法通过shoulda-matchers可以简化为：
  it {should belong_to(:category)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}

  describe "search_by_title" do
  	it "returns an empty array if there is no match" do
  		futurama = Video.create(title: "Futurama", description: "Space Trval!")
  		back_to_future = Video.create(title: "Back to Future", description: 'Time Trval!')
  		expect(Video.search_by_title("hello")).to eq([])
  	end

  	it "returns an array of one video for an exact match" do
  		futurama = Video.create(title: "Futurama", description: "Space Trval!")
  		back_to_future = Video.create(title: "Back to Future", description: 'Time Trval!')
  		expect(Video.search_by_title("Futurama")).to eq([futurama])
  	end

  	it "returns an array of one video for a partial match" do
  		futurama = Video.create(title: "Futurama", description: "Space Trval!")
  		back_to_future = Video.create(title: "Back to Future", description: 'Time Trval!')
  		expect(Video.search_by_title("urama")).to eq([futurama])
  	end
  	it "returns an array of all matches ordered by created_at" do
  		futurama = Video.create(title: "Futurama", description: "Space Trval!", created_at: 1.day.ago)
  		back_to_future = Video.create(title: "Back to Future", description: 'Time Trval!')
  		expect(Video.search_by_title("Futur")).to eq([back_to_future, futurama])
  	end
  	it "returns an empty array for a search with an empty string" do
  		futurama = Video.create(title: "Futurama", description: "Space Trval!", created_at: 1.day.ago)
  		back_to_future = Video.create(title: "Back to Future", description: 'Time Trval!')
  		expect(Video.search_by_title("")).to eq([])
  	end
  end
end
