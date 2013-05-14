#encoding: utf-8

class ElementsController < ApplicationController
  def new
  end

  def create
    category = Category[params[:category_id]]
    if element = Element.create(
                category: category,
                name: params[:element][:name],
                path: params[:element][:path]
              )
      redirect_to category_element_path(category_id: category.id, id: element.id)
    else
      flash[:notice] = 'Внимательно заполните все поля.'
      render :new
    end
  end

  def show
    @element = Element[params[:id]]
  end

  def index
    @elements = Category.find(id: params[:category_id]).first.elements
  end  
end
