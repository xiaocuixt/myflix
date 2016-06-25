class TodosController < ApplicationController

  def index
    @todos = Todo.all
    @todo = Todo.new
  end

  def new
	 @todo = Todo.new
  end

  def create
  	@todo = Todo.new(todo_params)
  	if @todo.save
      location_string = @todo.name.slice(/.*\bAT\b(.*)/, 1).try(:strip)
      if location_string
        locations = location_string.split(/\,|and/).map(&:strip)
        locations.each do |location|
          @todo.tags.create(name: "location:#{location}")
        end
      end
  		redirect_to root_path
  	else
  		render :new
  	end
  end

  private
  def todo_params
  	params.require(:todo).permit(:name, :description)
  end
end