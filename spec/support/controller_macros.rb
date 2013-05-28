module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      FactoryGirl.create(:editor_role)
      @admin = FactoryGirl.create(:user)
      @admin.roles << FactoryGirl.create(:admin_role)
      sign_in @admin
    end
  end

  def login_editor
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @editor = FactoryGirl.create(:user)
      @editor.roles << FactoryGirl.create(:editor_role)
      sign_in @editor
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
    end
  end

  def create_test_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @test_user = FactoryGirl.create(:user)
    end
  end
end
