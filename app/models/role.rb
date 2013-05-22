class Role < ActiveRecord::Base
  attr_accessible :name

  has_many :users_roles, uniq: true, dependent: :destroy
  has_many :users, through: :users_roles, uniq: true

  validates_presence_of   :name
  validates_uniqueness_of :name
end
