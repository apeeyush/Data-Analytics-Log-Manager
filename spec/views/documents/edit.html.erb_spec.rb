require 'spec_helper'

describe "documents/edit" do
  before(:each) do
    @document = assign(:document, stub_model(Document,
      :name => "MyString",
      :data => '{"data_key_1" : "data_value_1"}'
    ))
  end

  it "renders the edit document form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", document_path(@document), "post" do
      assert_select "input#document_name[name=?]", "document[name]"
      assert_select "input#document_data[name=?]", "document[data]"
    end
  end
end
