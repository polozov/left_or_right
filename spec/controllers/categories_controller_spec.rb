# encoding: utf-8
require 'spec_helper'

describe CategoriesController do
  render_views

  before(:all) do
    @category  = FactoryGirl.create(:category)
    @element_1 = FactoryGirl.create(:element, category: @category)
    @element_2 = FactoryGirl.create(:element, category: @category)
    @element_3 = FactoryGirl.create(:element, category: @category)

    @category_1  = FactoryGirl.create(:category)
    @category_2  = FactoryGirl.create(:category)
  end

  # garbage collection
  after(:all) do
    Element.all.each{ |elem| elem.delete if elem }
    Category.all.each{ |cat| cat.delete if cat }
  end

  context 'for guest user' do
    describe 'GET #new' do
      it 'should be redirect to login page' do
        get :new
        expect(response).to redirect_to new_user_session_path
        flash[:alert].should match /необходимо войти/
      end
    end

    describe 'POST #create' do
      it 'should be redirect to login page' do
        post :create, category: FactoryGirl.attributes_for(:category)
        expect(response).to redirect_to new_user_session_path
        flash[:alert].should match /необходимо войти/
      end
    end

    describe 'GET #edit' do
      it 'should be redirect to login page' do
        get :edit, id: @category.id
        expect(response).to redirect_to new_user_session_path
        flash[:alert].should match /необходимо войти/
      end
    end

    describe 'PUT #update' do
      it 'should be redirect to login page' do
        put :update, id: @category.id,
          category: FactoryGirl.attributes_for(:category, name: 'New Name')
        expect(response).to redirect_to new_user_session_path
        flash[:alert].should match /необходимо войти/
      end
    end

    describe 'GET #show' do
      it 'should be successful' do
        get :show, id: @category.id
        expect(response).to render_template :show
        expect(response.body).to match /Кто лучше?/
      end
    end

    describe 'GET #index' do
      it 'should be successful' do
        get :index
        expect(response).to render_template :index
        expect(response.body).to match /Все категории:/
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to login page' do
        delete :destroy, id: @category.id
        expect(response).to redirect_to new_user_session_path
        flash[:alert].should match /необходимо войти/
      end
    end
  end

  context 'for user' do
    login_user

    describe 'GET #new' do
      it 'should be redirect to login page' do
        get :new
        expect(response).to redirect_to root_path
        flash[:alert].should match /недостаточно полномочий/
      end
    end

    describe 'POST #create' do
      it 'should be redirect to login page' do
        post :create, category: FactoryGirl.attributes_for(:category)
        expect(response).to redirect_to root_path
        flash[:alert].should match /недостаточно полномочий/
      end
    end

    describe 'GET #edit' do
      it 'should be redirect to login page' do
        get :edit, id: @category.id
        expect(response).to redirect_to root_path
        flash[:alert].should match /недостаточно полномочий/
      end
    end

    describe 'PUT #update' do
      it 'should be redirect to login page' do
        put :update, id: @category.id,
          category: FactoryGirl.attributes_for(:category, name: 'New Name')
        expect(response).to redirect_to root_path
        flash[:alert].should match /недостаточно полномочий/
      end
    end

    describe 'GET #show' do
      it 'should be successful' do
        get :show, id: @category.id
        expect(response).to render_template :show
        expect(response.body).to match /Кто лучше?/
      end
    end

    describe 'GET #index' do
      it 'should be successful' do
        get :index
        expect(response).to render_template :index
        expect(response.body).to match /Все категории:/
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to login page' do
        delete :destroy, id: @category.id
        expect(response).to redirect_to root_path
        flash[:alert].should match /недостаточно полномочий/
      end
    end
  end

  context 'for editor' do
    login_editor

    describe 'GET #new' do
      it 'should be successful' do
        get :new, id: @category.id
        expect(response).to render_template :new
        expect(response.body).to match /Создать категорию:/
      end
    end

    describe 'POST #create' do
      it 'should be successful for valid category data' do
        post :create, category: FactoryGirl.attributes_for(:category)
        expect(response).to redirect_to(category_url(assigns(:category).id))
      end

      it 'should be failure for invalid category data (long name)' do
        post :create, category:
          FactoryGirl.attributes_for(:category, name: 'very_long_category_name')
        expect(response).to render_template :new
        expect(response.body).to match /Ошибка!/
      end

      it 'should be failure for invalid category data (name is blank)' do
        post :create, category: FactoryGirl.attributes_for(:category, name: '')
        expect(response).to render_template :new
        expect(response.body).to match /Ошибка!/
      end
    end

    describe 'GET #edit' do
      it 'should be successful' do
        get :edit, id: @category.id
        expect(response).to render_template :edit
        expect(response.body).to match /Редактировать категорию:/
      end
    end

    describe 'PUT #update' do
      it 'should be successful for valid category data' do
        put :update, id: @category.id,
          category: FactoryGirl.attributes_for(:category, name: 'Category_upd')
        expect(response).to redirect_to category_path(id: @category.id)
      end

      it 'should be failure for invalid category data (long name)' do
        put :update, id: @category.id,
          category: FactoryGirl.attributes_for(:category, name: 'Category_after_upd')
        expect(response).to render_template :edit
        expect(response.body).to match /Ошибка!/
      end

      it 'should be failure for invalid category data (name is blank)' do
        put :update, id: @category.id,
          category: FactoryGirl.attributes_for(:category, name: '')
        expect(response).to render_template :edit
        expect(response.body).to match /Ошибка!/
      end
    end

    describe 'GET #show' do
      it 'should be successful' do
        get :show, id: @category.id
        expect(response).to render_template :show
        expect(response.body).to match /Кто лучше?/
      end
    end

    describe 'GET #index' do
      it 'should be successful' do
        get :index, id: @category.id
        expect(response).to render_template :index
        expect(response.body).to match /Все категории:/
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to root page' do
        delete :destroy, id: @category_1.id
        expect(response).to redirect_to root_path
        flash[:notice].should match /Категория была удалена!/
      end
    end
  end

  context 'for admin' do
    login_admin

    describe 'GET #new' do
      it 'should be successful' do
        get :new, id: @category.id
        expect(response).to render_template :new
        expect(response.body).to match /Создать категорию:/
      end
    end

    describe 'POST #create' do
      it 'should be successful for valid category data' do
        post :create, category: FactoryGirl.attributes_for(:category)
        expect(response).to redirect_to(category_url(assigns(:category).id))
      end

      it 'should be failure for invalid category data (long name)' do
        post :create, category:
          FactoryGirl.attributes_for(:category, name: 'very_long_category_name')
        expect(response).to render_template :new
        expect(response.body).to match /Ошибка!/
      end

      it 'should be failure for invalid category data (name is blank)' do
        post :create, category: FactoryGirl.attributes_for(:category, name: '')
        expect(response).to render_template :new
        expect(response.body).to match /Ошибка!/
      end
    end

    describe 'GET #edit' do
      it 'should be successful' do
        get :edit, id: @category.id
        expect(response).to render_template :edit
        expect(response.body).to match /Редактировать категорию:/
      end
    end

    describe 'PUT #update' do
      it 'should be successful for valid category data' do
        put :update, id: @category.id,
          category: FactoryGirl.attributes_for(:category, name: 'Category_upd2')
        expect(response).to redirect_to category_path(id: @category.id)
      end

      it 'should be failure for invalid category data (long name)' do
        put :update, id: @category.id,
          category: FactoryGirl.attributes_for(:category, name: 'Category_after_upd2')
        expect(response).to render_template :edit
        expect(response.body).to match /Ошибка!/
      end

      it 'should be failure for invalid category data (name is blank)' do
        put :update, id: @category.id,
          category: FactoryGirl.attributes_for(:category, name: '')
        expect(response).to render_template :edit
        expect(response.body).to match /Ошибка!/
      end
    end

    describe 'GET #show' do
      it 'should be successful' do
        get :show, id: @category.id
        expect(response).to render_template :show
        expect(response.body).to match /Кто лучше?/
      end
    end

    describe 'GET #index' do
      it 'should be successful' do
        get :index, id: @category.id
        expect(response).to render_template :index
        expect(response.body).to match /Все категории:/
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to root page' do
        delete :destroy, id: @category_2.id
        expect(response).to redirect_to root_path
        flash[:notice].should match /Категория была удалена!/
      end
    end
  end
end
