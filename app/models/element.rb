class Element < Ohm::Model
  attribute :name
  attribute :path
  counter   :score
  reference :category, :Category

  index :category

  def validate
    assert_present :name
    assert_length  :name, 3..15
    assert_present :path
  end

  # удаление связанного с элементом изображения и удаление самого элемента
  def delete
    File.delete(Rails.root.join('app', 'assets', 'images', self.path)) if
      File.exist?(Rails.root.join('app', 'assets', 'images', self.path))
    super
  end

  # создание необходимых папок если они не существуют
  # element - вх. аргумент для определения класса объекта
  def create_directory_if_necessary
    unless Dir.exist?(
            Rails.root.join(
              'app', 'assets', 'images', 'uploads', "#{self.class.to_s.underscore}",
              "#{self.category.id.to_s}"
            )
          )
      Dir.chdir(Rails.root.join('app', 'assets', 'images'))
      Dir.mkdir('uploads') unless Dir.exist?('uploads')
      Dir.chdir('uploads')
      Dir.mkdir("#{self.class.to_s.underscore}") unless
        Dir.exist?("#{self.class.to_s.underscore}")
      Dir.chdir("#{self.class.to_s.underscore}")
      Dir.mkdir("#{self.category.id.to_s}") unless
        Dir.exist?("#{self.category.id.to_s}")
    end
  end

  # загрузка изображений
  def upload file, file_ext
    self.create_directory_if_necessary

    if file_ext #and file.content_type =~ /^image/i
      path_and_filename = ['uploads', "#{self.class.to_s.underscore}",
        "#{self.category.id.to_s}", "#{SecureRandom.hex(8)}.#{file_ext}"].join('/')
      File.open(
        Rails.root.join(
          'app', 'assets', 'images', path_and_filename), 'wb') do |uploaded_file|
        uploaded_file.write(file.read)
      end
      self.path = path_and_filename
    end
  end
end