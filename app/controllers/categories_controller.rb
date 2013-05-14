#encoding: utf-8

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
    if @category = Category[params[:id]] and @category.elements.size > 1
      @left, @right = Category.divination(@category.id)
    else
      flash[:notice] = 'Данная категория еще не заполнена.'
      redirect_to new_category_element_path(category_id: @category.id)
      #redirect_to root_path
    end
  end

  def index
    @categories = Category.all
  end
end
