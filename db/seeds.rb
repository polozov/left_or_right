# encoding: utf-8
#
# Attention! This task will remove all items from Redis DB!
#
#
# Удаляем все элементы и категории
Element.all.each{ |e| e.delete }
Category.all.each{ |c| c.delete }

# Создаем 3 категории, получаем id первой категории
cat_id = Category.create(name: 'Категория1').id.to_i
         Category.create(name: 'Категория2')
         Category.create(name: 'Категория3')

# Создаем 21 элемент в 3-х категориях
21.times do |i|
  element = Element.new name: "Элемент_#{i+1}", category: Category[cat_id + rand(3)]
  element.upload(Rails.root.join('db', 'rails.png'), 'png')
  element.save
end  
