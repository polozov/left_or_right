# encoding: utf-8
#
# Attention! This task will remove all items from Redis DB!
#
#
Element.all.each{ |e| e.delete }
Category.all.each{ |c| c.delete }

FileUtils.cp(Rails.root.join('db', 'rails.png'), Rails.root.join('app', 'assets', 'images', 'rails.png'))

cars  = Category.create name: 'Автомобили'
girls = Category.create name: 'Девушки'
boys  = Category.create name: 'Парни'

%w(Пежо Понтиак Порше Субару Джили).each do |c_name|
  Element.create name: c_name, path: 'rails.png', category: cars
end

%w(Роксана Алекса Тамара Евдокия Авдотья).each do |g_name|
  Element.create name: g_name, path: 'rails.png', category: girls
end

%w(Илья Егор Тимур Антон Семён).each do |b_name|
  Element.create name: b_name, path: 'rails.png', category: boys
end
