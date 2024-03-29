Кто лучше?
=====================

## Выбираете категорию и голосуете за понравившееся изображение. ##

### Описание: ###
Элементы распределены по категориям (автомобили, девушки, знаменитости и т.п.).
При голосовании пользователь видит 2 элемента из выбранной категории и может
отдать свой голос за один из них [элемент] или пропустить ход. 

### Правила просты: ###
1. Без регистрации можно только просматривать изображения.
2. Для голосования нужно зарегистрироваться.
3. За одно изображение можно голосовать только 1 раз.
4. Ход можно пропустить и не голосовать (кнопка " Пропустить ход").
4. Категории и элементы могут добавлять только редакторы.
5. Редакторов назначает (и "увольняет") администратор.

### Зависимости: ###
* **Redis** (запущен на **127.0.0.1:6379**) - [скачать](http://redis.io/download)
* **SQLite** (скоро будет заменен на **MySQL**) - [скачать](http://www.sqlite.org/download.html)
* Гемы из **Gemfile**

### Особенности: ###
* Элементы и категории хранятся в **Redis** (спасибо **Ohm**).
* Пользователи - в **SQLite** (скоро в **MySQ**L).
* Регистрация, вход\выход, сессии и т.п. - **Devise**.
* За привилегии (роли) благодарю **CanCan**.
* Css стили и "красивости" - **Twitter Bootstrap**. 
* Ну и никуда без **Rspec, FactoryGirl, Shoulda** и **Capybara**.

------------------------------------------------------------------
* Для заполнения БД примерами и создания администратора - `rake db:seed`
* Полное удаление всех элементов\категорий (с изображениями) - `rake db:redis_cleaning`


### Just for fun! ###