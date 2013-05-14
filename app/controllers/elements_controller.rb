class ElementsController < ApplicationController
  def new
  end

  def show
    @element = Element[params[:id]]
  end

  def index
    @elements = Category.find(id: params[:category_id]).first.elements
  end  
end
