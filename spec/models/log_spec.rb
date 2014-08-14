require 'spec_helper'

describe Log, :type => :model do

  it "returns key's value for a log" do
  	log = FactoryGirl.create(:log)
  	log.value('application') == log.application
  end

  it "updates value for a key" do
  	log = FactoryGirl.create(:log)
  	log.update_value('application','test_update')
  	log.application == 'test_update'
  end

  it "returns keys list" do
  	FactoryGirl.create_list(:log, 3)
  	logs = Log.where(application: 'myApplication')
  	logs.keys_list.should include("application")
  end

end
