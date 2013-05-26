# encoding: utf-8
require 'spec_helper'

describe UsersController do
  render_views

  context 'for guest user' do
    describe 'GET #index' do
      it 'should be redirect to login page' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'PUT #update' do
      it 'should be redirect to login page' do
        put :update, id: 'test_user_id' # id в данном случае может быть любым
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to login page' do
        delete :destroy, id: 'test_user_id' # id в данном случае может быть любым
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'for logged user' do
    login_user

    describe 'GET #index' do
      it 'should be redirect to root page' do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    describe 'PUT #update' do
      it 'should be redirect to root page' do
        put :update, id: @user.id
        expect(response).to redirect_to root_path
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to root page' do
        delete :destroy, id: @user.id
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'for admin' do
    login_admin
    create_test_user

    describe 'GET #index' do
      it 'should be successful for admin' do
        get :index
        expect(response).to render_template :index
        expect(response.body).to match /Пользователи:/
      end
    end

    describe 'PUT #update' do
      it 'should be update @user roles and redirect to users page' do
        # стоит перенести это из спеков контроллера
        expect{put :update, id: @test_user.id}.to change{@test_user.roles.count}.
          from(1).to(2)
        expect(response).to redirect_to users_path
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to login page' do
        delete :destroy, id: @test_user.id
        expect(response).to redirect_to users_path
      end
    end
  end
end
