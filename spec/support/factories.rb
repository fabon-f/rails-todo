FactoryGirl.define do
  factory :user do
    email "user@example.com"
    password "hogefuga"
    password_confirmation "hogefuga"
    username "example_user"
  end

  factory :admin, class: User do
    email "admin@example.com"
    password "admin_user"
    password_confirmation "admin_user"
    username "admin_user"
    role "admin"
  end

  factory :task do
    title "Lorem ipsum"
    user
  end
end
