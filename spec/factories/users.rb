# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email "test@email.com"
    password "password"
  end

  factory :user_with_application, :parent => :user do
    applications { [FactoryGirl.create(:application)] }
  end
end
