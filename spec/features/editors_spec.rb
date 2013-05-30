# encoding: utf-8
require 'spec_helper'
require 'support/test_features_helper'

describe 'Editors' do
  before { sign_in_as('editor@test.com', 'Test_editor', 'test_pass', 'editor') }

  before(:all) do
    @category_1  = FactoryGirl.create(:category, name: 'Категория_3')
    @element_1 = FactoryGirl.create(:element, name: 'Элемент_5', category: @category_1)
    @element_2 = FactoryGirl.create(:element, name: 'Элемент_6', category: @category_1)

    @category_2  = FactoryGirl.create(:category, name: 'Категория_4')
    @element_3 = FactoryGirl.create(:element, name: 'Элемент_7', category: @category_2)
    @element_4 = FactoryGirl.create(:element, name: 'Элемент_8', category: @category_2)
  end

  describe 'root page' do
    before { visit '/' }

    it 'should have standard user menu' do
      page.should have_content('Вы зарегистрированы как – Test_editor')
      page.should have_content('Профиль')
      page.should have_content('Выйти')
    end

    it 'should not have link "Users" for ordinary users' do
      page.should_not have_content('Пользователи')
    end

    it 'should have links to categories' do
      page.should have_content('Все категории:')
      page.should have_content('Категория_4')
    end
  end

  describe 'category page' do
    before { visit "/categories/#{@category_2.id}" }

    it 'should have standart labels' do
      page.should have_content("#{@category_2.name}")
      page.should have_content('2 элемента')
      page.should have_content('Кто лучше?')
    end

    it 'should have 2 elements for voting' do
      page.should have_content("#{@element_3.name}")
      page.should have_content('Голосов: 0')
      page.should have_content("#{@element_4.name}")
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
      current_path.should == category_path(@category_2.id)
    end

    it 'should have button "Pass a move"' do
      page.should have_content('Пропустить ход')
    end

    it 'should reload current page when you press button "Pass a move"' do
      current_path.should == category_path(@category_2.id)
      click_on('Пропустить ход')
      current_path.should == category_path(@category_2.id)
    end

    it 'should redirect to root page when you press button "Home"' do
      current_path.should == category_path(@category_2.id)
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
      fill_in('Никнэйм', with: 'Test12345')
      fill_in('Текущий пароль', with: 'test_pass')
      click_on('Сохранить')
      page.should have_content('Ваша учётная запись изменена.')
      page.should have_content('Вы зарегистрированы как – Test12345')
    end
  end

  describe 'main menu' do
    it 'should redirect to the profile editing page when you press button "Profile"' do
      click_on('Профиль')
      current_path.should == edit_user_registration_path
    end

    it 'should redirect to the root page and do log out when you press button "Exit"' do
      click_on('Выйти')
      current_path.should == root_path
      page.should have_content('Выход из системы выполнен.')
      page.should have_content('Зарегистрироваться или Войти')
    end
  end

  describe 'reset button' do
    it 'should delete user account and redirect to the root page' do
      click_on('Профиль')
      click_on('Удалить мой аккаунт')
      current_path.should == root_path
      page.should have_content(
        'До свидания! Ваша учётная запись удалена. Надеемся снова увидеть Вас.')
      page.should have_content('Зарегистрироваться или Войти')

      # попытка входа после удаления аккаунта
      click_on('Войти')
      fill_in('Электронная почта', with: 'editor@test.com')
      fill_in('Пароль', with: 'test_pass')

      within('.new_user') do
        click_on('Войти')
      end

      page.should have_content('Неверный пароль или email.')
    end
  end

  describe 'forbidden actions' do
    it 'visit users page should redirect to root page and show alert message' do
      visit '/users'
      current_path.should == root_path
      page.should have_content('У Вас недостаточно полномочий для этого действия.')
    end
  end

  describe 'can' do
    it 'create new categories' do
      visit '/'
      click_on('Создать категорию')
      current_path.should == new_category_path
      page.should have_content('Наименование')
      page.should have_content('Изображение')

      fill_in('Наименование', with: 'Категория нов.')
      attach_file('Изображение', Rails.root.join('spec', 'fixtures', 'rails.png'))
      click_on('Сохранить')

      # redirect to new elements path
      page.should have_content('Данная категория еще не заполнена.')
      page.should have_content('Создать элемент:')
      page.should have_content('Наименование')
      page.should have_content('Изображение')

      click_on('На главную')
      current_path.should == root_path
      page.should have_content('Категория нов.')
      page.should have_content('0 элементов')
    end

    it 'edit categories' do
      visit '/'
      first(:link, 'Редактировать').click
      page.should have_content('Редактировать категорию:')
      page.should have_content('Изменить изображение нельзя!')

      fill_in('Наименование', with: 'Категория_123')
      click_on('Сохранить')

      # # redirect to category show path
      current_path.should == category_path(@category_1.id)
      page.should have_content('Категория_123')
      page.should have_content('Кто лучше?')
      page.should have_content('Управление элементами')
      page.should have_content('Создать элемент')
    end

    it 'delete categories' do
      visit '/'
      # removing of the last category
      page.all('a', text: 'Удалить')[-1].click
      current_path.should == root_path
      page.should have_content('Категория была удалена!')
      page.should_not have_content('Категория нов.')
    end

    it 'create new elements' do
      visit '/'
      click_on('Категория_4')
      current_path.should == category_path(@category_2.id)

      click_on('Создать элемент')
      current_path.should == new_category_element_path(@category_2.id)
      page.should have_content('Создать элемент:')
      page.should have_content('Наименование')
      page.should have_content('Изображение')

      fill_in('Наименование', with: 'Новый элемент')
      attach_file('Изображение', Rails.root.join('spec', 'fixtures', 'rails.png'))
      click_on('Сохранить')

      # redirect to created element path
      page.should have_content('Выбранный элемент:')
      page.should have_content('Новый элемент')
      page.should have_content('Назад в категорию')
    end

    it 'edit elements' do
      visit '/'
      click_on('Категория_4')
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

      fill_in('Наименование', with: 'Элемент_12345')
      click_on('Сохранить')

      # redirect to element show path
      page.should have_content('Выбранный элемент:')
      page.should have_content('Элемент_12345')
      page.should have_content('Назад в категорию')      
    end

    it 'delete elements' do
      visit '/'
      click_on('Категория_4')
      current_path.should == category_path(@category_2.id)

      # redirect to element index path
      click_on('Управление элементами')
      current_path.should == category_elements_path(@category_2.id)

      first(:link, 'Удалить').click
      current_path.should == category_elements_path(@category_2.id)
      page.should have_content('Элемент был удален!')
      page.should_not have_content('Элемент_12345')
    end
  end
end
