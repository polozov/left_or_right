#encoding: utf-8

class ElementsController < ApplicationController
  def new
  end

  def create
    category = Category[params[:category_id]]
    element = Element.new(
      category: category, name: params[:element][:name], path: params[:element][:path])
    file_ext = check_file_type(element.path.original_filename)

    if element.valid? and element.upload(element.path, file_ext)
      element.save
      redirect_to category_element_path(category_id: category.id, id: element.id)
    else
      flash.now[:notice] = 'Ошибка! Наименование - не менее 3-х символов;
        допустимые форматы изображения - JPG, JPEG или PNG).'
      render :new
    end
  end

  def show
    @element = Element[params[:id]]
  end

  def index
    @elements = Category.find(id: params[:category_id]).first.elements
  end

  def destroy
    if element = Element[params[:id]]
      element.delete
    else
      flash[:error] = "Произошла ошибка! Элемент не удален!"
    end
    redirect_to category_elements_path(category_id: params[:category_id])    
  end

  def vote
    if category = Category[params[:category_id]] and element = Element[params[:id]]
      vote_up(category, element)
    else
      flash[:notice] = 'Hacker detected!'
      redirect_to root_path
    end
  end
end