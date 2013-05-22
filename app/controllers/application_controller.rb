#encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from Ohm::UniqueIndexViolation do
    redirect_to root_path, alert: 'Наименование категории должно быть уникальным!'
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  private

  # возвращает расширение файла если файл является изображением
  def check_file_type file_name
    if file_name =~ /(jpg|jpeg|png)$/i
      file_name["#{file_name =~ /(jpg|jpeg|png)$/i}".to_i..-1].downcase
    end
  end

  # CanCan проверяет права на выполнение экшена для определенной
  # модели и в случае отсутствия таких прав отправляет в root_path;
  # action - имя выполняемого действия, model - проверяемая модель,
  # можно передавать экземпляр модели или саму модель (Category, Element ...)
  def cancan_authorize! action, model
    authorize! action, model,
      message: 'У Вас недостаточно полномочий для этого действия.'
  end
end
