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
end