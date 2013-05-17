#encoding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  # создание необходимых папок если они не существуют
  # element - вх. аргумент для определения класса объекта
  def create_directory_if_necessary element
    unless Dir.exist?(
            Rails.root.join(
              'app', 'assets', 'images', 'uploads', "#{element.class.to_s.underscore}",
              "#{element.category.id.to_s}"
            )
          )
      Dir.chdir(Rails.root.join('app', 'assets', 'images'))
      Dir.mkdir('uploads') unless Dir.exist?('uploads')
      Dir.chdir('uploads')
      Dir.mkdir("#{element.class.to_s.underscore}") unless
        Dir.exist?("#{element.class.to_s.underscore}")
      Dir.chdir("#{element.class.to_s.underscore}")
      Dir.mkdir("#{element.category.id.to_s}") unless
        Dir.exist?("#{element.category.id.to_s}")
    end
  end

  # возвращает расширение файла если файл является изображением
  def check_file_type file_name
    if file_name =~ /(jpg|jpeg|png)$/i
      file_name["#{file_name =~ /(jpg|jpeg|png)$/i}".to_i..-1].downcase
    end
  end

  # загрузка изображений
  def upload file, element, category_id
    create_directory_if_necessary(element)
    file_ext = check_file_type(file.original_filename)

    if file_ext #and file.content_type =~ /^image/i
      path_and_filename = ['uploads', "#{element.class.to_s.underscore}",
        "#{element.category.id.to_s}", "#{SecureRandom.hex(8)}.#{file_ext}"].join('/')
      File.open(
        Rails.root.join(
          'app', 'assets', 'images', path_and_filename), 'wb') do |uploaded_file|
        uploaded_file.write(file.read)
      end
      element.path = path_and_filename
    end
  end

  # начисление голосов
  def vote_up category, element
    if element.incr('score')
      flash[:notice] = "#{element.name.capitalize} получил(а) Ваш голос!"
    else
      flash[:error] = "Произошла ошибка!"
    end
    redirect_to category_path(id: category.id)
  end 
end
