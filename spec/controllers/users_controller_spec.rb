# encoding: utf-8
require 'spec_helper'

describe UsersController do
  render_views

  context 'for guest' do
    describe 'GET #index' do
      it 'should be redirect to login page' do
        get :index
        expect(response).to redirect_to new_user_session_path
        flash[:alert].should match /необходимо войти/
      end
    end

    describe 'PUT #update' do
      it 'should be redirect to login page' do
        put :update, id: 1 # id не имеет значения в данном случае (может быть любым)
        expect(response).to redirect_to new_user_session_path
        flash[:alert].should match /необходимо войти/
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to login page' do
        delete :destroy, id: 1 # id не имеет значения в данном случае (может быть любым)
        expect(response).to redirect_to new_user_session_path
        flash[:alert].should match /необходимо войти/
      end
    end
  end

  context 'for user' do
    login_user
    create_test_user

    describe 'GET #index' do
      it 'should be redirect to root page' do
        get :index
        expect(response).to redirect_to root_path
        flash[:alert].should match /недостаточно полномочий/
      end
    end

    describe 'PUT #update' do
      it 'should be redirect to root page' do
        put :update, id: @test_user.id
        expect(response).to redirect_to root_path
        flash[:alert].should match /недостаточно полномочий/
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to root page' do
        delete :destroy, id: @test_user.id
        expect(response).to redirect_to root_path
        flash[:alert].should match /недостаточно полномочий/
      end
    end
  end

  context 'for editor' do
    login_editor
    create_test_user

    describe 'GET #index' do
      it 'should be redirect to root page' do
        get :index
        expect(response).to redirect_to root_path
        flash[:alert].should match /недостаточно полномочий/
      end
    end

    describe 'PUT #update' do
      it 'should be redirect to root page' do
        put :update, id: @test_user.id
        expect(response).to redirect_to root_path
        flash[:alert].should match /недостаточно полномочий/
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to root page' do
        delete :destroy, id: @test_user.id
        expect(response).to redirect_to root_path
        flash[:alert].should match /недостаточно полномочий/
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

        # при первом вызове :update пользователь получает роль :editor
        expect{put :update, id: @test_user.id}.to change{@test_user.roles.count}.
          from(1).to(2)
        expect(response).to redirect_to users_path
        flash[:notice].should include(
          "Пользователь '#{@test_user.username}' переведен в редакторы!")

        # при втором вызове :update пользователь лишается роли :editor
        expect{put :update, id: @test_user.id}.to change{@test_user.roles.count}.
          from(2).to(1)
        expect(response).to redirect_to users_path
        flash[:notice].should include(
          "Пользователь '#{@test_user.username}' исключен из редакторов!")
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to login page' do
        # стоит перенести это из спеков контроллера
        expect{delete :destroy, id: @test_user.id}.to change{User.count}.by(-1)
        expect(response).to redirect_to users_path
        flash[:notice].should include(
          "Пользователь '#{@test_user.username}' был удален!")
      end
    end
  end
end
