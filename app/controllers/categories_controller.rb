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
      flash.now[:notice] = 'Ошибка! Наименование - не менее 3-х символов.'
      render :new
    end
  end

  def show
    if @category = Category[params[:id]] and @category.elements.size > 1
      @left, @right = Category.divination(@category.id)
    else
      flash[:notice] = 'Данная категория еще не заполнена.'
      redirect_to new_category_element_path(category_id: @category.id)
    end
  end

  def index
    @categories = Category.all
  end

  def destroy
    if category = Category[params[:id]]
      category.elements.each{ |e| e.delete } if category.elements.any?
      category.delete
    else
      flash[:error] = 'Данная категория не существует!'
    end
    redirect_to root_path
  end
end
