require 'spec_helper'

describe "documents/show", :type => :view do
  before(:each) do
    @document = assign(:document, stub_model(Document,
      :name => "Name",
      :data => '{"data_key_1" : "data_value_1"}'
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    expect(rendered).to match(/Name/)
    expect(rendered).to include("data_key_1")
    expect(rendered).to include("data_value_1")
  end
end
