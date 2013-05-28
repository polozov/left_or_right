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

require 'spec_helper'

describe User do

  # ActiveRecord
  it { should have_many(:users_roles).dependent(:destroy) }
  it { should have_many(:roles).through(:users_roles) }

  # ActiveModel
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should ensure_length_of(:username).is_at_least(4) }
  it { should ensure_length_of(:username).is_at_most(16) }

  context 'model method' do
    before(:all) do
      uniq_username = "Test_#{SecureRandom.hex(4)}"
      uniq_email    = "#{uniq_username}@test.com"
      @test_user = FactoryGirl.create(:user,
        username: uniq_username, email: uniq_email)
    end

    context 'action has_role?' do
      it 'should return true if user has this role' do
        expect(@test_user.has_role?(:user)).to be_true
      end

      it 'should return false if user has not this role' do
        expect(@test_user.has_role?(:editor)).to be_false
        expect(@test_user.has_role?(:admin)).to be_false
        expect(@test_user.has_role?(:god)).to be_false
      end
    end

    context 'action add_user_role' do
      it 'should add role :user to User instance' do
        expect(@test_user.roles).to include(Role.find_by_name(:user))
        expect(@test_user.roles.size).to eql(1)
      end
    end
  end
end
