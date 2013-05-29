# encoding: utf-8
require 'spec_helper'

def sign_in_as(email, username, password)
  user = FactoryGirl.build(:user, 
    email:    email,
    username: username,
    password: password,
    password_confirmation: password
  )
  user.save!

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
