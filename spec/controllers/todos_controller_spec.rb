require "spec_helper"

describe TodosController do
	describe "GET index" do
		it "set the @todos variable" do
			cook = Todo.create(name: "cook")
			sleep = Todo.create(name: "sleep")
			get :index
			assigns(:todos).should == [cook, sleep]
		end
		it "renders the index template" do
			get :index
			response.should render_template :index
		end
	end

	describe "GET new" do
		it "set the @todo variable" do
			get :new
			assigns(:todo).should be_new_record
			assigns(:todo).should be_instance_of(Todo)
		end

		it "renders the new template" do
			get :new
			response.should render_template :new
		end
	end

	describe "POST create" do
		it "create the todo record when the input is valid" do
			post :create, todo: {name: "cook", description: "I like cooking!"}
			Todo.first.name.should == "cook"
			Todo.first.description.should == "I like cooking!"
		end
		it "redirect to the root path when the input is valid" do
			post :create, todo: {name: "cook", description: "I like cooking!"}
			response.should redirect_to root_path
		end
		it "renders the new template when the input is invalid" do
		  post :create, todo: {description: "I like cooking!"}
		  response.should render_template :new
		end
		it "does not create a todo when the input is invalid" do
		  post :create, todo: {description: "I like cooking!"}
		  Todo.count.should == 0
		end
	end
end