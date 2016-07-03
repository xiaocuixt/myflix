require "spec_helper"

describe TodosController do
  before do
    set_todo_current_user
  end

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
    it "redirects user to the sign in path if they are not signed in" do
      clear_current_user
      get :index
      response.should redirect_to sign_in_path
    end

    it_behaves_like "require_sign_in" do
      let(:action) {get :index}
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
    it_behaves_like "require_sign_in" do
      let(:action) {get :new}
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
    it "does not create tags without inline locations" do
      post :create, todo: {name: "cook"}
      Tag.count.should == 0
    end
    it "does not create tags with at in a word without inline locations" do
      post :create, todo: {name: "eat an apple"}
      Tag.count.should == 0
    end
    it "create a tag with upcase AT" do
      post :create, todo: {name: "shop AT the Apple Store"}
      Tag.all.map(&:name).should == ["location:the Apple Store"]
    end
    context "with inline locations" do
      it "creates a tag with one location" do
        post :create, todo: {name: "cook AT home"}
        Tag.all.map(&:name).should ==['location:home']
      end
      it "creates two tags with two locations" do
        post :create, todo: {name: "cook AT home and work"}
        Tag.all.map(&:name).should ==['location:home', 'location:work']
      end
      it "creates mutiple tags with mutiple locations" do
        post :create, todo: {name: "cook AT home, work, school and library"}
        Tag.all.map(&:name).should ==['location:home', 'location:work', 'location:school', 'location:library']
      end
      it_behaves_like "require_sign_in" do
        let(:action) {post :create, todo: {name: "something"}}
      end
    end
  end
end