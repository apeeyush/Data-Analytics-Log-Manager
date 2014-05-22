require 'spec_helper'

describe "logs/index" do
  before(:each) do
    assign(:logs, [
      stub_model(Log,
        :session => "Session",
        :user => "User",
        :application => "Application",
        :activity => "Activity",
        :event => "Event",
        :parameters => "",
        :extras => ""
      ),
      stub_model(Log,
        :session => "Session",
        :user => "User",
        :application => "Application",
        :activity => "Activity",
        :event => "Event",
        :parameters => "",
        :extras => ""
      )
    ])
  end

  it "renders a list of logs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Session".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "Application".to_s, :count => 2
    assert_select "tr>td", :text => "Activity".to_s, :count => 2
    assert_select "tr>td", :text => "Event".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
