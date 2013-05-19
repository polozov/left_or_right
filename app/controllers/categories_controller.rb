#encoding: utf-8

class CategoriesController < ApplicationController
  rescue_from Ohm::UniqueIndexViolation, with: :name_is_not_unique
  before_filter :category_finder, only: [:edit, :update, :show, :destroy]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      redirect_to category_path(@category.id)
    else
      flash.now[:error] = 'Ошибка! Наименование - должно содержать 3..15 символов.'
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(name: params[:category][:name])
      redirect_to category_path(@category.id)
    else
      flash.now[:error] = 'Ошибка! Наименование - должно содержать 3..15 символов.'
      render :edit
    end
  end

  def show
    if @category and @category.elements.size > 1
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
    if @category
      @category.elements.each{ |e| e.delete } if @category.elements.any?
      @category.delete
    else
      flash[:error] = 'Данная категория не существует!'
    end
    redirect_to root_path
  end

  private

  def name_is_not_unique
    flash[:error] = 'Наименование категории должно быть уникальным!'
    redirect_to root_path
  end

  def category_finder
    @category = Category[params[:id]]
  end
end
