# encoding: utf-8
require 'spec_helper'

def sign_in_as(email, username, password, role=nil)
  user = FactoryGirl.build(:user, 
    email:    email,
    username: username,
    password: password,
    password_confirmation: password
  )
  user.save!
  
  user.roles << Role.find_by_name(role.to_sym) if role

  visit '/'
  click_on('Войти')
  fill_in('Электронная почта', with: user.email)
  fill_in('Пароль', with: password)

  within('.new_user') do
    click_on('Войти')
  end

  user
end

def sign_out
  click_on('Выйти')
end

def create_test_users
  @user_0 = FactoryGirl.build(:user,
    username: 'User_0', email: 'test_0@test.com',
    password: 'password', password_confirmation: 'password')
  @user_1 = FactoryGirl.build(:user,
    username: 'User_1', email: 'test_1@test.com',
    password: 'password', password_confirmation: 'password')
  @user_2 = FactoryGirl.build(:user,
    username: 'User_2', email: 'test_2@test.com',
    password: 'password', password_confirmation: 'password')
  @user_3 = FactoryGirl.build(:user,
    username: 'User_3', email: 'test_3@test.com',
    password: 'password', password_confirmation: 'password')
  @user_0.save!
  @user_1.save!
  @user_2.save!
  @user_3.save!
end
