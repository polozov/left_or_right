# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  username               :string(255)      default(""), not null
#

class User < ActiveRecord::Base
  before_create :add_role

  has_many :users_roles, uniq: true, dependent: :destroy
  has_many :roles, through: :users_roles, uniq: true

  validates :username, presence: true,
                       uniqueness: true,
                       length: (4..16)

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :trackable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :password, :password_confirmation, :remember_me

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
