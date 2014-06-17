require 'spec_helper'

describe "documents/index", :type => :view do
  before(:each) do
    assign(:documents, [
      stub_model(Document,
        :name => "Name",
        :data => '{"data_key_1" : "data_value_1"}'
      ),
      stub_model(Document,
        :name => "Name",
        :data => '{"data_key_1" : "data_value_1"}'
      )
    ])
  end

  it "renders a list of documents" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    data = Hash.new
    data["data_key_1"] = "data_value_1"
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", data, :count => 2
  end
end
