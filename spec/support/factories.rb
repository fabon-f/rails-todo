FactoryGirl.define do
  factory :user do
    email "user@example.com"
    password "hogefuga"
    password_confirmation "hogefuga"
    username "example_user"
  end

  factory :task do
    title "Lorem ipsum"
    user
  end
end
