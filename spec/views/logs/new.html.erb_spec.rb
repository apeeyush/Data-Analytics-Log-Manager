require 'spec_helper'

describe "logs/new" do
  before(:each) do
    assign(:log, stub_model(Log,
      :session => "MyString",
      :username => "MyString",
      :application => "MyString",
      :activity => "MyString",
      :event => "MyString",
      :parameters => "",
      :extras => ""
    ).as_new_record)
  end

  it "renders new log form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", logs_path, "post" do
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
