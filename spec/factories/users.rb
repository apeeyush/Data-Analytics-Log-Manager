# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "test@email.com"
    password "password"
    password_confirmation "password"
  end

  factory :user_with_application, :parent => :user do
    applications { [FactoryGirl.create(:application)] }
    after(:create) { |user| user.confirm! }
  end
end
