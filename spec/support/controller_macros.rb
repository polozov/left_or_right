module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @admin = FactoryGirl.create(:user)
      @admin.roles << Role.find_by_name(:admin)
      sign_in @admin
    end
  end

  def login_editor
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @editor = FactoryGirl.create(:user)
      @editor.roles << Role.find_by_name(:editor)
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
end
