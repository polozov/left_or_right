# encoding: utf-8
require 'spec_helper'
require 'support/test_features_helper'

describe 'Admins' do
  before { sign_in_as('admin@test.com', 'Test_admin', 'test_pass', 'admin') }

  before(:all) do
    @category_1 = FactoryGirl.create(:category, name: 'Категория_9')
    @element_1 = FactoryGirl.create(:element, name: 'Элемент_16', category: @category_1)
    @element_2 = FactoryGirl.create(:element, name: 'Элемент_17', category: @category_1)

    @category_2 = FactoryGirl.create(:category, name: 'Категория_10')
    @element_3 = FactoryGirl.create(:element, name: 'Элемент_18', category: @category_2)
    @element_4 = FactoryGirl.create(:element, name: 'Элемент_19', category: @category_2)
    @element_5 = FactoryGirl.create(:element, name: 'Элемент_20', category: @category_2)

    @category_3 = FactoryGirl.create(:category, name: 'Категория_11')
    @element_6 = FactoryGirl.create(:element, name: 'Элемент_21', category: @category_3)
    @element_7 = FactoryGirl.create(:element, name: 'Элемент_22', category: @category_3)
  end

  describe 'root page' do
    before { visit '/' }

    it 'should have standard user menu' do
      page.should have_content('Вы зарегистрированы как – Test_admin')
      page.should have_content('Профиль')
      page.should have_content('Выйти')
    end

    it 'should have link "Users"' do
      page.should have_content('Пользователи')
    end

    it 'should have links to categories' do
      page.should have_content('Все категории:')
      page.should have_content("#{@category_1.name}")
    end
  end

  describe 'category page' do
    before { visit "/categories/#{@category_1.id}" }

    it 'should have standart labels' do
      page.should have_content("#{@category_1.name}")
      page.should have_content('2 элемента')
      page.should have_content('Кто лучше?')
    end

    it 'should have 2 elements for voting' do
      page.should have_content("#{@element_1.name}")
      page.should have_content('Голосов: 0')
      page.should have_content("#{@element_2.name}")
      page.should have_content('Голосов: 0')
    end

    it 'should have vote buttons "< Left!" and "Rigth! >"' do
      page.should have_content('< Слева!')
      page.should have_content('Справа! >')
    end

    it 'should increment element score if you press vote button' do
      click_on('< Слева!')
      page.should have_content("получил(а) Ваш голос!")
      page.should have_content('Голосов: 1')
      current_path.should == category_path(@category_1.id)
    end

    it 'should have button "Pass a move"' do
      page.should have_content('Пропустить ход')
    end

    it 'should reload current page when you press button "Pass a move"' do
      current_path.should == category_path(@category_1.id)
      click_on('Пропустить ход')
      current_path.should == category_path(@category_1.id)
    end

    it 'should redirect to root page when you press button "Home"' do
      current_path.should == category_path(@category_1.id)
      click_on('На главную')
      current_path.should == root_path
    end
  end

  describe 'profile page' do
    before { click_on 'Профиль' }

    it 'should have standart labels' do
      page.should have_content('Редактировать')
      page.should have_content('Эл. почта')
      page.should have_content('Никнэйм')
      page.should have_content('Новый пароль')
      page.should have_content('Подтверждение нового пароля')
      page.should have_content('Текущий пароль')
      page.should have_content('Удалить мой аккаунт')
      page.should have_content('Недовольны?')
      page.should have_content('Назад')
    end

    it 'should raise an error if the user does not fill the current password' do
      fill_in('Никнэйм', with: 'Test123')
      click_on('Сохранить')
      page.should have_content('сохранение не удалось из-за 1 ошибки')
      page.should have_content('Current password не может быть пустым')
    end

    it 'should redirect to the root page after user nickname changing' do
      fill_in('Никнэйм', with: 'Test_admin1')
      fill_in('Текущий пароль', with: 'test_pass')
      click_on('Сохранить')
      page.should have_content('Ваша учётная запись изменена.')
      page.should have_content('Вы зарегистрированы как – Test_admin1')
    end
  end

  describe 'main menu' do
    it 'should redirect to the profile editing page when you press button "Profile"' do
      click_on('Профиль')
      current_path.should == edit_user_registration_path
    end

    it 'should redirect to the users management page when you press button "Users"' do
      click_on('Пользователи')
      current_path.should == users_path
      page.should have_content('Пользователи:')
      page.should have_content('На главную')
    end

    it 'should redirect to the root page and do log out when you press button "Exit"' do
      click_on('Выйти')
      current_path.should == root_path
      page.should have_content('Выход из системы выполнен.')
      page.should have_content('Зарегистрироваться или Войти')
    end
  end

  describe '"Users" page' do
    before(:all) { create_test_users }
    before { click_on('Пользователи') }

    it 'should contain all test users' do
      page.should have_content('Имя: User_1')
      page.should have_content('Эл. почта: test_1@test.com')
      page.should have_content('Имя: User_2')
      page.should have_content('Эл. почта: test_2@test.com')
      page.should have_content('Имя: User_3')
      page.should have_content('Эл. почта: test_3@test.com')
    end

    it 'should contain management buttons' do
      page.should have_content('В редакторы!')
      page.should have_content('Удалить')
    end

    it 'should extend users permissions (from users to editors)' do
      # search button 'В редакторы!' for @user_1
      all('a', text: 'В редакторы!').each do |a|
        a.click if a[:href] =~ %r{users\/#{@user_1.id}}
      end
      page.should have_content("Пользователь 'User_1' переведен в редакторы!")
      page.should have_content('В пользователи!')
    end

    it 'should downgrade users permissions (from editors to users)' do
      # upgrade the last user to the editor

      # search button 'В редакторы!' for @user_2
      all('a', text: 'В редакторы!').each do |a|
        a.click if a[:href] =~ %r{users\/#{@user_2.id}}
      end
      page.should have_content("Пользователь 'User_2' переведен в редакторы!")

      # downgrade the last editor to the user

      # search button 'В пользователи!' for @user_2
      all('a', text: 'В пользователи!').each do |a|
        a.click if a[:href] =~ %r{users\/#{@user_2.id}}
      end
      page.should have_content("Пользователь 'User_2' исключен из редакторов!")
    end

    it 'should delete users' do
      # search button 'Delete' for @user_3
      all('a', text: 'Удалить').each do |a|
        a.click if a[:href] =~ %r{users\/#{@user_3.id}}
      end

      page.should have_content("Пользователь 'User_3' был удален!")
      current_path.should == users_path
    end
  end

  describe 'reset button' do
    it 'should delete admin account and redirect to the root page' do
      click_on('Профиль')
      click_on('Удалить мой аккаунт')
      current_path.should == root_path
      page.should have_content(
        'До свидания! Ваша учётная запись удалена. Надеемся снова увидеть Вас.')
      page.should have_content('Зарегистрироваться или Войти')

      # попытка входа после удаления аккаунта
      click_on('Войти')
      fill_in('Электронная почта', with: 'admin@test.com')
      fill_in('Пароль', with: 'test_pass')

      within('.new_user') do
        click_on('Войти')
      end

      page.should have_content('Неверный пароль или email.')
    end
  end

  describe 'can' do
    before(:all) { @category_4 = FactoryGirl.create(:category, name: 'Категория_99') }
    before { visit '/' }

    it 'create new categories' do
      click_on('Создать категорию')
      current_path.should == new_category_path
      page.should have_content('Наименование')
      page.should have_content('Изображение')

      fill_in('Наименование', with: 'Категория нов1')
      attach_file('Изображение', Rails.root.join('spec', 'fixtures', 'rails.png'))
      click_on('Сохранить')

      # redirect to new elements path
      page.should have_content('Данная категория еще не заполнена.')
      page.should have_content('Создать элемент:')
      page.should have_content('Наименование')
      page.should have_content('Изображение')

      click_on('На главную')
      current_path.should == root_path
      page.should have_content('Категория нов1')
      page.should have_content('0 элементов')
    end

    it 'edit categories' do
      visit edit_category_path(@category_3.id)
      page.should have_content('Редактировать категорию:')
      page.should have_content('Изменить изображение нельзя!')

      fill_in('Наименование', with: 'Категория_987')
      click_on('Сохранить')

      # redirect to category show path
      current_path.should == category_path(@category_3.id)
      page.should have_content('Категория_987')
      page.should have_content('Кто лучше?')
      page.should have_content('Управление элементами')
      page.should have_content('Создать элемент')
    end

    it 'delete categories' do
      page.should have_content('Категория_99')

      # search button 'Delete' for @category_4
      all('a', text: 'Удалить').each do |a|
        a.click if a[:href] =~ %r{categories\/#{@category_4.id}}
      end

      current_path.should == root_path
      page.should have_content('Категория была удалена!')
      page.should_not have_content('Категория_99')
    end

    it 'create new elements' do
      click_on('Категория_10')
      current_path.should == category_path(@category_2.id)

      click_on('Создать элемент')
      current_path.should == new_category_element_path(@category_2.id)
      page.should have_content('Создать элемент:')
      page.should have_content('Наименование')
      page.should have_content('Изображение')

      fill_in('Наименование', with: 'Новый элемент1')
      attach_file('Изображение', Rails.root.join('spec', 'fixtures', 'rails.png'))
      click_on('Сохранить')

      # redirect to created element path
      page.should have_content('Выбранный элемент:')
      page.should have_content('Новый элемент1')
      page.should have_content('Назад в категорию')
    end

    it 'edit elements' do
      click_on('Категория_10')
      current_path.should == category_path(@category_2.id)

      # redirect to element index path
      click_on('Управление элементами')
      current_path.should == category_elements_path(@category_2.id)
      page.should have_content('Все элементы категории:')
      page.should have_content('Редактировать')
      page.should have_content('Удалить')

      first(:link, 'Редактировать').click
      # redirect to element edit path
      page.should have_content('Редактировать элемент:')
      page.should have_content('Изменить изображение нельзя!')

      fill_in('Наименование', with: 'Элемент_98765')
      click_on('Сохранить')

      # redirect to element show path
      page.should have_content('Выбранный элемент:')
      page.should have_content('Элемент_98765')
      page.should have_content('Назад в категорию')      
    end

    it 'delete elements' do
      click_on('Категория_10')
      current_path.should == category_path(@category_2.id)

      # redirect to element index path
      click_on('Управление элементами')
      current_path.should == category_elements_path(@category_2.id)

      # search button 'Delete' for @element_3
      all('a', text: 'Удалить').each do |a|
        if a[:href] =~ %r{categories\/#{@category_2.id}\/elements\/#{@element_3.id}}
          a.click
        end
      end
      current_path.should == category_elements_path(@category_2.id)
      page.should have_content('Элемент был удален!')
      page.should_not have_content("#{@element_3.name}")
    end
  end
end
