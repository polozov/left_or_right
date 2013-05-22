# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ActiveRecord::Base
  attr_accessible :name

  has_many :users_roles, uniq: true, dependent: :destroy
  has_many :users, through: :users_roles, uniq: true

  validates :name, presence: true,
                   uniqueness: true,
                   length: (3..18)
end
