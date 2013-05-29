# encoding: utf-8
require 'spec_helper'
require 'support/test_features_helper'

describe 'Users' do
  before { sign_in_as('test@test.com', 'Test_user', 'test_pass') }

  before(:all) do
    @category_1  = FactoryGirl.create(:category, name: 'Автомобили')
    @element_1 = FactoryGirl.create(:element, name: 'Фиат', category: @category_1)

    @category_2  = FactoryGirl.create(:category, name: 'Девушки')
    @element_2 = FactoryGirl.create(:element, name: 'Даша', category: @category_2)
    @element_3 = FactoryGirl.create(:element, name: 'Маша', category: @category_2)
  end

  describe 'root page' do
    before { visit '/' }

    it 'should have standard user menu' do
      page.should have_content('Вы зарегистрированы как – Test_user')
      page.should have_content('Профиль')
      page.should have_content('Выйти')
    end

    it 'should not have link "Users" for ordinary users' do
      page.should_not have_content('Пользователи')
    end

    it 'should have links to categories' do
      page.should have_content('Автомобили')
      page.should have_content('1 элемент')
      page.should have_content('Девушки')
      page.should have_content('2 элемента')
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
      page.should have_content("#{@element_2.name}")
      page.should have_content('Голосов: 0')
      page.should have_content("#{@element_3.name}")
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
      fill_in('Никнэйм', with: 'Test123')
      fill_in('Текущий пароль', with: 'test_pass')
      click_on('Сохранить')
      page.should have_content('Ваша учётная запись изменена.')
      page.should have_content('Вы зарегистрированы как – Test123')
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
      fill_in('Электронная почта', with: 'test@test.com')
      fill_in('Пароль', with: 'test_pass')

      within('.new_user') do
        click_on('Войти')
      end

      page.should have_content('Неверный пароль или email.')
    end
  end

  describe 'forbidden actions' do
    it 'visit users page should redirect to root page and show alert message' do
      visit 'users'
      current_path.should == root_path
      page.should have_content('У Вас недостаточно полномочий для этого действия.')
    end

    it 'visit new category page should redirect to root page and show alert message' do
      visit 'categories/new'
      current_path.should == root_path
      page.should have_content('У Вас недостаточно полномочий для этого действия.')
    end

    it 'visit new elements page should redirect to root page and show alert message' do
      visit "categories/#{@category_2.id}/elements/new"
      current_path.should == root_path
      page.should have_content('У Вас недостаточно полномочий для этого действия.')
    end

    it 'visit edit category page should redirect to root page and show alert message' do
      visit "categories/#{@category_2.id}/edit"
      current_path.should == root_path
      page.should have_content('У Вас недостаточно полномочий для этого действия.')
    end
    
    it 'visit edit elements page should redirect to root page and show alert message' do
      visit "categories/#{@category_2.id}/elements/#{@element_2.id}/edit"
      current_path.should == root_path
      page.should have_content('У Вас недостаточно полномочий для этого действия.')
    end
  end
end
