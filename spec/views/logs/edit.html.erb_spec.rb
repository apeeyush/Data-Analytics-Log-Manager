require 'spec_helper'

describe "logs/edit" do
  before(:each) do
    @log = assign(:log, stub_model(Log,
      :session => "MyString",
      :username => "MyString",
      :application => "MyString",
      :activity => "MyString",
      :event => "MyString",
      :parameters => "",
      :extras => ""
    ))
  end

  it "renders the edit log form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", log_path(@log), "post" do
      assert_select "input#log_session[name=?]", "log[session]"
      assert_select "input#log_username[name=?]", "log[username]"
      assert_select "input#log_application[name=?]", "log[application]"
      assert_select "input#log_activity[name=?]", "log[activity]"
      assert_select "input#log_event[name=?]", "log[event]"
      assert_select "input#log_parameters[name=?]", "log[parameters]"
      assert_select "input#log_extras[name=?]", "log[extras]"
    end
  end
end
