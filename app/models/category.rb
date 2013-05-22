class Category < Ohm::Model
  attribute  :name
  unique     :name
  attribute  :image
  collection :elements, :Element

  index :elements

  def validate
    assert_present :name
    assert_length  :name, 3..15
    assert_present :image
  end

  def delete
    File.delete(Rails.root.join('app', 'assets', 'images', self.image)) if
      File.exist?(Rails.root.join('app', 'assets', 'images', self.image))
    super    
  end

  def self.divination category_id
    Category[category_id].elements.to_a.sample(2)
  end

  # создание необходимых папок для картинок категории если они не существуют
  def create_directory_if_necessary
    unless Dir.exist?(
            Rails.root.join(
              'app', 'assets', 'images', 'uploads', "#{self.class.to_s.underscore}"
            )
          )
      Dir.chdir(Rails.root.join('app', 'assets', 'images'))
      Dir.mkdir('uploads') unless Dir.exist?('uploads')
      Dir.chdir('uploads')
      Dir.mkdir("#{self.class.to_s.underscore}") unless
        Dir.exist?("#{self.class.to_s.underscore}")
    end
  end

  # метод загружающий картинку для категории
  # file - файл картинки, file_ext - расширение файла картинки
  # файл картинки получает случайное имя на основе ф-ии SecureRandom
  def upload file, file_ext
    self.create_directory_if_necessary
    if file_ext
      path_and_filename = ['uploads', "#{self.class.to_s.underscore}",
        "#{SecureRandom.hex(8)}.#{file_ext}"].join('/')
      File.open(
        Rails.root.join(
          'app', 'assets', 'images', path_and_filename), 'wb') do |uploaded_file|
        uploaded_file.write(file.read)
      end
      self.image = path_and_filename
    end
  end

  # метод проверки уникальности имени категории
  # это дублирование "unique :name" вызванно тем, что уникальность имени Ohm проверяет
  # после сохранения категории и в случае не уникальности делает откат;
  # такое поведение не устраивает - т.к. category#index успевает загрузить картинку 
  def name_unique?
    unless self.name.to_s.blank?
      categories = Category.all

      categories.each do |category|
        return false if category.name.downcase == self.name.to_s.downcase
      end

      true
    end
  end
end