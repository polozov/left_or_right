class User < ActiveRecord::Base
  before_create :add_role

  has_many :users_roles, uniq: true, dependent: :destroy
  has_many :roles, through: :users_roles, uniq: true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :trackable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  # проверка для CanCan - есть ли у пользователя данная роль
  def has_role? role
    self.roles.include? Role.find_by_name(role.to_s)
  end  

  private

  # колбэк, который добавляет пользователю роль
  def add_role
    if User.count.zero?
      self.roles << Role.find_by_name(:admin)
    else
      self.roles << Role.find_by_name(:user)
    end
  end

end
