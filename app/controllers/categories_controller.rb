#encoding: utf-8

class CategoriesController < ApplicationController
  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :category_finder, only: [:edit, :update, :show, :destroy]
  rescue_from Ohm::UniqueIndexViolation, with: :name_is_not_unique

  def new
    cancan_authorize! :new, Category
    @category = Category.new
  end

  def create
    cancan_authorize! :create, Category

    @category = Category.new(params[:category])
    file_ext = check_file_type(@category.image.original_filename) if @category.image

    if @category.valid? and @category.upload(@category.image, file_ext)
      @category.save
      redirect_to category_path(@category.id)
    else
      flash.now[:alert] = 'Ошибка! Наименование 3..15 символов;
        допустимые форматы изображения - JPG, JPEG или PNG).'
      render :new
    end
  end

  def edit
    cancan_authorize! :edit, @category
  end

  def update
    cancan_authorize! :update, @category

    if @category.update(name: params[:category][:name])
      redirect_to category_path(@category.id)
    else
      flash.now[:alert] = 'Ошибка! Наименование - должно содержать 3..15 символов.'
      render :edit
    end
  end

  def show
    cancan_authorize! :show, @category

    if @category and @category.elements.size > 1
      @left, @right = Category.divination(@category.id)
    else
      flash[:notice] = 'Данная категория еще не заполнена.'
      redirect_to new_category_element_path(category_id: @category.id)
    end
  end

  def index
    cancan_authorize! :index, Category
    @categories = Category.all
  end

  def destroy
    cancan_authorize! :destroy, @category

    if @category
      @category.elements.each{ |e| e.delete } if @category.elements.any?
      @category.delete
    else
      flash[:alert] = 'Данная категория не существует!'
    end
    redirect_to root_path
  end

  private

  def name_is_not_unique
    flash[:alert] = 'Наименование категории должно быть уникальным!'
    redirect_to root_path
  end

  def category_finder
    @category = Category[params[:id]]
  end
end
