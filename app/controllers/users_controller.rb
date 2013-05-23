# encoding: utf-8

class UsersController < ApplicationController
  before_filter :authenticate_user!  
  before_filter :user_finder, only: [:update, :destroy]

  def index
    cancan_authorize! :index, User

    main_admin = User.first
    # @users = User.includes(:roles).all.delete_if{ |user| user == current_user || user == main_admin }
    @users = User.all.delete_if{ |user| user == current_user || user == main_admin }
  end

  def update
    cancan_authorize! :update, User

    if @user.has_role? :editor
      @user.roles.delete Role.find_by_name(:editor)
      flash[:notice] = "Пользователь '#{@user.username}' исключен из редакторов!"
    else
      @user.roles << Role.find_by_name(:editor)
      flash[:notice] = "Пользователь '#{@user.username}' переведен в редакторы!"
    end

    redirect_to users_path
  end

  def destroy
    cancan_authorize! :destroy, User

    @user.destroy
    redirect_to users_path,
      notice: "Пользователь '#{@user.username}' был удален!"
  end

  private

  def user_finder
    @user = User.find(params[:id])
  end
end
