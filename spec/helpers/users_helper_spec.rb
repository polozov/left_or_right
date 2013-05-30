# encoding: utf-8
require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
#

describe UsersHelper do
  context 'link_to_change_privileges' do
    before(:all) do
      @test_user = FactoryGirl.build(:user,
        username: 'User_helper', email: 'test_user@test.com',
        password: 'password', password_confirmation: 'password')

      @test_user.save!
    end

    # this links are very ugly :(

    it 'should generate link to change user privileges' do
      # link to go from the user to the editor
      expect(helper.link_to_change_privileges @test_user).to eql(
        '<a href="/users/' + "#{@test_user.id}" + '" class=' +
        '"btn btn-success btn-small" data-confirm="Изменить привилегии пользователя?" ' +
        'data-method="put" rel="nofollow">В редакторы!</a>')

      # add editor role
      @test_user.roles << Role.find_by_name(:editor)
      # link to go from the editor to the user
      expect(helper.link_to_change_privileges @test_user).to eql(
        '<a href="/users/' + "#{@test_user.id}" + '" class=' +
        '"btn btn-success btn-small" data-confirm="Изменить привилегии пользователя?" ' +
        'data-method="put" rel="nofollow">В пользователи!</a>')
    end
  end
end
