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
      flash.now[:notice] = 'Внимательно заполните все поля.'
      render :new
    end
  end

  def show
    @element = Element[params[:id]]
  end

  def index
    @elements = Category.find(id: params[:category_id]).first.elements
  end

  def vote
    if category = Category[params[:category_id]] and element = Element[params[:id]]
      vote_up(category, element)
    else
      flash[:notice] = 'Hacker detected!'
      redirect_to root_path
    end
  end

  private

  def vote_up category, element
    # начисление голосов
    if element.incr('score')
      flash[:notice] = "#{element.name.capitalize} получил(а) Ваш голос!"
    else
      flash[:error] = "Произошла ошибка!"
    end
    redirect_to category_path(id: category.id)
  end
end
