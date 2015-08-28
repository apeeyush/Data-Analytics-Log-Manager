# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :log_spreadsheet do
    user_id 1
    status "MyString"
    progress_msg "MyString"
    spreadsheet ""
  end
end
