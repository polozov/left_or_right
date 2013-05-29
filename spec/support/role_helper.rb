module RoleHelper
  def self.create_user_role
    FactoryGirl.create(:user_role) if Role.find_by_name(:user).nil?
  end
end
