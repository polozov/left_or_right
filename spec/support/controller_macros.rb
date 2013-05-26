module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      FactoryGirl.create(:user_role)
      FactoryGirl.create(:editor_role)
      @admin = FactoryGirl.create(:user)
      @admin.roles << FactoryGirl.create(:admin_role)
      sign_in @admin
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      FactoryGirl.create(:user_role)
      @user = FactoryGirl.create(:user)
      sign_in @user
    end
  end

  # def logout_admin
  #   before(:each) do
  #     @request.env["devise.mapping"] = Devise.mappings[:user]
  #     sign_out @admin
  #   end
  # end

  def create_test_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @test_user = FactoryGirl.create(:user)
    end
  end
end
