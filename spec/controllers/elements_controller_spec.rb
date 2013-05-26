# encoding: utf-8
require 'spec_helper'

describe ElementsController do
  render_views

  before(:all) do
    @category  = FactoryGirl.create(:category)
    @element_1 = FactoryGirl.create(:element, category: @category)
    @element_2 = FactoryGirl.create(:element, category: @category)
    @element_3 = FactoryGirl.create(:element, category: @category)
    @element_4 = FactoryGirl.create(:element, category: @category)
  end

  after(:all) do
    Element.all.each{ |elem| elem.delete if elem }
    Category.all.each{ |cat| cat.delete if cat }
  end

  context 'for guest' do
    describe 'GET #new' do
      it 'should be redirect to login page' do
        get :new, category_id: @category.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      it 'should be redirect to login page' do
        post :create, category_id: @category.id,
          element: FactoryGirl.attributes_for(:element)
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #edit' do
      it 'should be redirect to login page' do
        get :edit, category_id: @category.id, id: @element_1.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'PUT #update' do
      it 'should be redirect to login page' do
        put :update, category_id: @category.id, id: @element_1.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #show' do
      it 'should be redirect to login page' do
        get :show, category_id: @category.id, id: @element_1.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'GET #index' do
      it 'should be redirect to login page' do
        get :index, category_id: @category.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to login page' do
        delete :destroy, category_id: @category.id, id: @element_1.id
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  context 'for user' do
    login_user

    describe 'GET #new' do
      it 'should be redirect to login page' do
        get :new, category_id: @category.id
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      it 'should be redirect to login page' do
        post :create, category_id: @category.id,
          element: FactoryGirl.attributes_for(:element)
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #edit' do
      it 'should be redirect to login page' do
        get :edit, category_id: @category.id, id: @element_1.id
        expect(response).to redirect_to root_path
      end
    end

    describe 'PUT #update' do
      it 'should be redirect to login page' do
        put :update, category_id: @category.id, id: @element_1.id
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #show' do
      it 'should be redirect to login page' do
        get :show, category_id: @category.id, id: @element_1.id
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #index' do
      it 'should be redirect to login page' do
        get :index, category_id: @category.id
        expect(response).to redirect_to root_path
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to login page' do
        delete :destroy, category_id: @category.id, id: @element_1.id
        expect(response).to redirect_to root_path
      end
    end
  end

  context 'for editor' do
    login_editor

    describe 'GET #new' do
      it 'should be successful' do
        get :new, category_id: @category.id
        expect(response).to render_template :new
        expect(response.body).to match /Создать элемент:/
      end
    end

    describe 'POST #create' do
      xit 'should be successful for valid elements' do
        post :create, category_id: @category.id,
          element: FactoryGirl.attributes_for(:element)
        expect(response).to redirect_to(category_element_url(assigns(@category.id), assigns(:element)))
      end
    end

    describe 'GET #edit' do
      it 'should be successful' do
        get :edit, category_id: @category.id, id: @element_1.id
        expect(response).to render_template :edit
        expect(response.body).to match /Редактировать элемент:/
      end
    end

    describe 'PUT #update' do
      it 'should be successful for valid elements data' do
        put :update, category_id: @category.id, id: @element_2.id,
          element: FactoryGirl.attributes_for(:element, name: 'Element_updated')
        expect(response).to redirect_to category_element_path(
          category_id: @category.id, id: @element_2.id)
      end

      it 'should be failure for invalid elements data (long name)' do
        put :update, category_id: @category.id, id: @element_2.id,
          element: FactoryGirl.attributes_for(:element, name: 'Element_after_update')
        expect(response).to render_template :edit
        expect(response.body).to match /Ошибка!/
      end

      it 'should be failure for invalid elements data (name is blank)' do
        put :update, category_id: @category.id, id: @element_2.id,
          element: FactoryGirl.attributes_for(:element, name: '')
        expect(response).to render_template :edit
        expect(response.body).to match /Ошибка!/
      end
    end

    describe 'GET #show' do
      it 'should be successful' do
        get :show, category_id: @category.id, id: @element_1.id
        expect(response).to render_template :show
        expect(response.body).to match /Выбранный элемент:/
      end
    end

    describe 'GET #index' do
      it 'should be successful' do
        get :index, category_id: @category.id
        expect(response).to render_template :index
        expect(response.body).to match /Все элементы категории:/
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to category page' do
        delete :destroy, category_id: @category.id, id: @element_3.id
        expect(response).to redirect_to category_elements_path(
          category_id: @category.id)
      end
    end
  end

  context 'for admin' do
    login_admin

    describe 'GET #new' do
      it 'should be successful' do
        get :new, category_id: @category.id
        expect(response).to render_template :new
        expect(response.body).to match /Создать элемент:/
      end
    end

    describe 'POST #create' do
      xit 'should be successful for valid elements' do
        post :create, category_id: @category.id,
          element: FactoryGirl.attributes_for(:element)
        expect(response).to redirect_to(category_element_url(assigns(@category.id), assigns(:element)))
      end
    end

    describe 'GET #edit' do
      it 'should be successful' do
        get :edit, category_id: @category.id, id: @element_1.id
        expect(response).to render_template :edit
        expect(response.body).to match /Редактировать элемент:/
      end
    end

    describe 'PUT #update' do
      it 'should be successful for valid elements data' do
        put :update, category_id: @category.id, id: @element_2.id,
          element: FactoryGirl.attributes_for(:element, name: 'Element_updated')
        expect(response).to redirect_to category_element_path(
          category_id: @category.id, id: @element_2.id)
      end

      it 'should be failure for invalid elements data (long name)' do
        put :update, category_id: @category.id, id: @element_2.id,
          element: FactoryGirl.attributes_for(:element, name: 'Element_after_update')
        expect(response).to render_template :edit
        expect(response.body).to match /Ошибка!/
      end

      it 'should be failure for invalid elements data (name is blank)' do
        put :update, category_id: @category.id, id: @element_2.id,
          element: FactoryGirl.attributes_for(:element, name: '')
        expect(response).to render_template :edit
        expect(response.body).to match /Ошибка!/
      end
    end

    describe 'GET #show' do
      it 'should be successful' do
        get :show, category_id: @category.id, id: @element_1.id
        expect(response).to render_template :show
        expect(response.body).to match /Выбранный элемент:/
      end
    end

    describe 'GET #index' do
      it 'should be successful' do
        get :index, category_id: @category.id
        expect(response).to render_template :index
        expect(response.body).to match /Все элементы категории:/
      end
    end

    describe 'DELETE #destroy' do
      it 'should be redirect to category page' do
        delete :destroy, category_id: @category.id, id: @element_4.id
        expect(response).to redirect_to category_elements_path(
          category_id: @category.id)
      end
    end
  end
end
