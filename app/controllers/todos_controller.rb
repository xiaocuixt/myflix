class TodosController < ApplicationController
  before_filter do
    redirect_to :root if Rails.env.production?
  end

 def new
  @todo = Todo.new
  render layout: nil
 end
end