include ActionDispatch::TestProcess

# registered_user (user.rb)
FactoryGirl.define do
  factory :user do
    sequence(:email)    { |n| "email_#{n}@test.com" }
    sequence(:username) { |n| "Test_user_#{n}" }
    password '123456789'
  end
end

# user_role (role.rb)
FactoryGirl.define do
  factory :user_role, class: Role do
    name 'user'
  end
end

# editor_role (role.rb)
FactoryGirl.define do
  factory :editor_role, class: Role do
    name 'editor'
  end
end

# admin_role (role.rb)
FactoryGirl.define do
  factory :admin_role, class: Role do
    name 'admin'
  end
end

# test_category (category.rb)
FactoryGirl.define do
  factory :category, class: Category do
    sequence(:name) { |n| "test_category#{n}"}
    image {fixture_file_upload(Rails.root.join(
          'spec', 'fixtures', 'rails.png'), 'image/png')}
  end
end

# test_element (element.rb)
FactoryGirl.define do
  factory :element, class: Element do
    sequence(:name) { |n| "test_element#{n}"}
    image {fixture_file_upload(Rails.root.join(
          'spec', 'fixtures', 'rails.png'), 'image/png')}
    category
  end
end
