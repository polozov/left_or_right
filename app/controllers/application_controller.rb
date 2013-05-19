#encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  # возвращает расширение файла если файл является изображением
  def check_file_type file_name
    if file_name =~ /(jpg|jpeg|png)$/i
      file_name["#{file_name =~ /(jpg|jpeg|png)$/i}".to_i..-1].downcase
    end
  end

  # начисление голосов
  def vote_up element
    if element.incr('score')
      flash[:notice] = "#{element.name.capitalize} получил(а) Ваш голос!"
    else
      flash[:error] = "Произошла ошибка!"
    end
    redirect_to category_path(id: element.category.id)
  end 
end
