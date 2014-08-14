# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :log do
  	application "myApplication"
  	activity "myActivity"
  	username "myUser"
  	event "myEvent"
  end
end
