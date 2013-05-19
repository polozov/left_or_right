#encoding: utf-8

class ElementsController < ApplicationController
  before_filter :element_finder, only: [:edit, :update, :show, :destroy, :vote]

  def new
    @element = Element.new
  end

  def create
    category = Category[params[:category_id]]
    @element = Element.new(
      category: category, name: params[:element][:name], path: params[:element][:path])
    file_ext = check_file_type(@element.path.original_filename) if @element.path

    if @element.valid? and @element.upload(@element.path, file_ext)
      @element.save
      redirect_to category_element_path(category_id: category.id, id: @element.id)
    else
      flash.now[:error] = 'Ошибка! Наименование - не менее 3-х символов;
        допустимые форматы изображения - JPG, JPEG или PNG).'
      render :new
    end
  end

  def edit
  end

  def update
    if @element.update(name: params[:element][:name])
      redirect_to category_element_path(
        category_id: @element.category.id, id: @element.id)
    else
      flash.now[:error] = 'Ошибка! Наименование - должно содержать 3..15 символов.'
      render :edit
    end
  end

  def show
    category = Category[params[:category_id]]

    if @element.nil? or category.nil? or @element.category.id != category.id
      flash[:error] = 'Произошла досадная ошибка!'
      redirect_to root_path
    end 
  end

  def index
    @elements = Category[params[:category_id]].elements
  end

  def destroy
    if @element and @element.category.id == params[:category_id]
      @element.delete
      flash[:error] = 'Элемент был удален!'
    else
      flash[:error] = 'Произошла ошибка! Элемент не удален!'
    end
    redirect_to category_elements_path(category_id: params[:category_id])    
  end

  # простая проверка при голосовании
  def vote
    if @element and @element.category.id == params[:category_id]
      vote_up(@element)
    else
      flash[:notice] = 'Hacker detected!'
      redirect_to root_path
    end
  end

  private

  def element_finder
    @element = Element[params[:id]]    
  end
end
