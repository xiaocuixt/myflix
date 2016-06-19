require "spec_helper"

describe Todo do
	describe "#name_only?" do
		it "returns true if the description is nil" do
			todo = Todo.new(name: "cook dinner")
			todo.name_only?.should be_truthy
		end
		it "returns true if the description is an empty string" do
			todo = Todo.new(name: "cook dinner", description: "")
			todo.name_only?.should be_truthy
		end
		it "returns true if the description is a non empty string" do
			todo = Todo.new(name: "cook dinner", description: "Photo")
			todo.name_only?.should be_falsey
		end
	end

	describe "#display_text" do
		let (:todo) {Todo.create(name: "cook dinner")}  #等价于 todo = Todo.create(name: "cook dinner"),并放置在before_filter中
    let (:subject) {todo.display_text}

    context "no tags" do
    	it { should == "cook dinner"}
    end

		context "one tag" do
			before {todo.tags.create(name: "home")}
    	it { should == "cook dinner (tag: home)"}
		end

		context "mutiple tags" do
			before do
				todo.tags.create(name: "home")
			  todo.tags.create(name: "urgent")
			end
			it { should == "cook dinner (tags: home, urgent)"}
		end

		context "more than four tags" do
			before do
				todo.tags.create(name: "home")
				todo.tags.create(name: "urgent")
				todo.tags.create(name: "help")
				todo.tags.create(name: "book")
				todo.tags.create(name: "patience")
			end
			it { should == "cook dinner (tags: home, urgent, help, book, more...)"}
		end
	end
end