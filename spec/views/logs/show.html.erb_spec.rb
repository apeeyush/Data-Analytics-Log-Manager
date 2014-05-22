require 'spec_helper'

describe "logs/show" do
  before(:each) do
    @log = assign(:log, stub_model(Log,
      :session => "Session",
      :user => "User",
      :application => "Application",
      :activity => "Activity",
      :event => "Event",
      :parameters => "",
      :extras => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Session/)
    rendered.should match(/User/)
    rendered.should match(/Application/)
    rendered.should match(/Activity/)
    rendered.should match(/Event/)
    rendered.should match(//)
    rendered.should match(//)
  end
end
