class CategoriesController < ApplicationController
  def new
  end

  def show
    @category = Category[params[:id]]
  end

  def index
    @categories = Category.all
  end
end
