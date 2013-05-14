class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    category = Category.new(params[:category])
    if category.save
      redirect_to category_path(category.id)
    else
      render :new
    end
  end

  def show
    @category = Category[params[:id]]
  end

  def index
    @categories = Category.all
  end
end
