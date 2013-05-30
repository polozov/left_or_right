# encoding: utf-8
require 'spec_helper'
require 'support/test_features_helper'

describe 'Guests' do
  # before { sign_in_as('test@test.com', 'Test_user', 'test_pass') }

  before(:all) do
    @category_1  = FactoryGirl.create(:category, name: 'Категория_1')
    @element_1 = FactoryGirl.create(:element, name: 'Элемент_1', category: @category_1)
    @element_2 = FactoryGirl.create(:element, name: 'Элемент_3', category: @category_1)

    @category_2  = FactoryGirl.create(:category, name: 'Категория_2')
    @element_3 = FactoryGirl.create(:element, name: 'Элемент_3', category: @category_2)
    @element_4 = FactoryGirl.create(:element, name: 'Элемент_4', category: @category_2)
  end

  describe 'root page' do
    before { visit '/' }

    it 'should have standard menu' do
      page.should have_content('Зарегистрироваться или Войти')
    end

    it 'should not have links "Profile" and "Exit"' do
      page.should_not have_content('Профиль')
      page.should_not have_content('Выйти')
    end

    it 'should not have link "Users" for ordinary users' do
      page.should_not have_content('Пользователи')
    end

    it 'should have links to categories' do
      page.should have_content('Все категории:')
      page.should have_content('Категория_1')
      page.should have_content('2 элемента')
      page.should have_content('Категория_2')
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
      page.should have_content("#{@element_3.name}")
      page.should have_content('Голосов: 0')
      page.should have_content("#{@element_4.name}")
      page.should have_content('Голосов: 0')
    end

    it 'should have vote buttons "< Left!" and "Rigth! >"' do
      page.should have_content('< Слева!')
      page.should have_content('Справа! >')
    end

    it 'should not increment element score if you press vote button' do
      click_on('< Слева!')
      page.should have_content('Вам необходимо войти в систему или зарегистрироваться.')
      current_path.should == new_user_session_path
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

  describe 'main menu' do
    it 'should redirect to the sign in page when you press button "Sign in"' do
      visit '/'
      click_on('Войти')
      current_path.should == new_user_session_path
    end

    it 'should redirect to the sign up page when you press button "Sign up"' do
      visit '/'
      click_on('Зарегистрироваться')
      current_path.should == new_user_registration_path
    end
  end

  describe 'forbidden actions' do
    it 'visit users page should redirect to root page and show alert message' do
      visit '/users'
      current_path.should == new_user_session_path
      page.should have_content('Вам необходимо войти в систему или зарегистрироваться.')
    end

    it 'visit new category page should redirect to root page and show alert message' do
      visit '/categories/new'
      current_path.should == new_user_session_path
      page.should have_content('Вам необходимо войти в систему или зарегистрироваться.')
    end

    it 'visit new elements page should redirect to root page and show alert message' do
      visit "/categories/#{@category_2.id}/elements/new"
      current_path.should == new_user_session_path
      page.should have_content('Вам необходимо войти в систему или зарегистрироваться.')
    end

    it 'visit edit category page should redirect to root page and show alert message' do
      visit "/categories/#{@category_2.id}/edit"
      current_path.should == new_user_session_path
      page.should have_content('Вам необходимо войти в систему или зарегистрироваться.')
    end
    
    it 'visit edit elements page should redirect to root page and show alert message' do
      visit "/categories/#{@category_2.id}/elements/#{@element_2.id}/edit"
      current_path.should == new_user_session_path
      page.should have_content('Вам необходимо войти в систему или зарегистрироваться.')
    end
  end
end
