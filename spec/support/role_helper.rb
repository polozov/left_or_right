module RoleHelper
  def self.create_user_role
    FactoryGirl.create(:user_role) if Role.find_by_name(:user).nil?
    FactoryGirl.create(:editor_role) if Role.find_by_name(:editor).nil?
    FactoryGirl.create(:admin_role) if Role.find_by_name(:admin).nil?
  end
end
