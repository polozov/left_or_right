# encoding: utf-8
#
# Attention! This task will remove all items from Redis DB, all users and roles!
#
#
# Удаляем все элементы и категории вместе с их изображениями
Element.all.each{ |e| e.delete if e }
Category.all.each{ |c| c.delete if c }

# Создаем 3 категории ('Категория_1'..'Категория_3')
# Для каждой категории создаем 5 элементов ('Элемент_1_1'..'Элемент_3_5')
1.upto(3) do |c|
  category = Category.new name: "Категория_#{c}"
  category.upload(Rails.root.join('db', 'group.png'), 'png')
  category.save

  1.upto(5) do |e|
    element = Element.new name: "Элемент_#{c}_#{e}", category: category
    element.upload(Rails.root.join('db', 'element.png'), 'png')
    element.save
  end
end
puts 'Создаем категории и элементы...'

#
# Удаляем пользователей и роли
#
User.delete_all
Role.delete_all
UsersRole.delete_all

# 
# Создаем необходимые роли для пользователей
#
admin_role = Role.create! name: 'admin'
Role.create! name: 'editor'
Role.create! name: 'user'

#
# Создаем первого пользователя - админа
# Пароль лучше бы сразу изменить :)
#
admin = User.create! username: 'Admin', email: 'admin@test.com',
  password: '123456789', password_confirmation: '123456789'

#
# Делаем первого пользователя админом
#
admin.roles << admin_role

puts 'Создаем пользователей и роли...'
puts 'Задание успешно выполнено.'
