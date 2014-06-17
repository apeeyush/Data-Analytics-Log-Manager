require 'spec_helper'

describe "logs/show", :type => :view do
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
    expect(rendered).to match(/Session/)
    expect(rendered).to match(/User/)
    expect(rendered).to match(/Application/)
    expect(rendered).to match(/Activity/)
    expect(rendered).to match(/Event/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
