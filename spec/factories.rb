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
