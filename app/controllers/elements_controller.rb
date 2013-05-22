#encoding: utf-8

class ElementsController < ApplicationController
  before_filter :authenticate_user!  
  before_filter :element_finder, only: [:edit, :update, :show, :destroy, :vote]

  def new
    cancan_authorize! :new, Element
    @element = Element.new
  end

  def create
    cancan_authorize! :create, Element

    category = Category[params[:category_id]]
    @element = Element.new(
      category: category, name: params[:element][:name], image: params[:element][:image])
    file_ext = check_file_type(@element.image.original_filename) if @element.image

    if @element.valid? and @element.upload(@element.image, file_ext)
      @element.save
      redirect_to category_element_path(category_id: category.id, id: @element.id)
    else
      flash.now[:alert] = 'Ошибка! Наименование 3..15 символов;
        допустимые форматы изображения - JPG, JPEG или PNG).'
      render :new
    end
  end

  def edit
    cancan_authorize! :edit, @element
  end

  def update
    cancan_authorize! :update, @element

    if @element.update(name: params[:element][:name])
      redirect_to category_element_path(
        category_id: @element.category.id, id: @element.id)
    else
      flash.now[:alert] = 'Ошибка! Наименование должно содержать 3..15 символов.'
      render :edit
    end
  end

  def show
    cancan_authorize! :show, @element
    category = Category[params[:category_id]]

    if @element.nil? or category.nil? or @element.category.id != category.id
      redirect_to root_path, alert: 'Произошла досадная ошибка!'
    end 
  end

  def index
    cancan_authorize! :index, Element
    @elements = Category[params[:category_id]].elements
  end

  def destroy
    cancan_authorize! :destroy, @element

    if @element and @element.category.id == params[:category_id]
      @element.delete
      flash[:notice] = 'Элемент был удален!'
    else
      flash[:alert] = 'Произошла ошибка! Элемент не удален!'
    end
    redirect_to category_elements_path(category_id: params[:category_id])
  end

  # простая проверка при голосовании
  def vote
    cancan_authorize! :vote, @element

    if @element and @element.category.id == params[:category_id]
      vote_up(@element)
    else
      redirect_to root_path, alert: 'Hacker detected!'
    end
  end

  private

  def element_finder
    @element = Element[params[:id]]
  end
end
