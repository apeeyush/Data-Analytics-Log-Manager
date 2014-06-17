require 'spec_helper'

describe "documents/new", :type => :view do
  before(:each) do
    assign(:document, stub_model(Document,
      :name => "MyString",
      :data => '{"data_key_1" : "data_value_1"}'
    ).as_new_record)
  end

  it "renders new document form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", documents_path, "post" do
      assert_select "input#document_name[name=?]", "document[name]"
      assert_select "input#document_data[name=?]", "document[data]"
    end
  end
end
