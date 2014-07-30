require 'rails_helper'

RSpec.describe "data_queries/index", :type => :view do
  before(:each) do
    assign(:data_queries, [
      DataQuery.create!(
        :content => "",
        :user => nil
      ),
      DataQuery.create!(
        :content => "",
        :user => nil
      )
    ])
  end

  it "renders a list of data_queries" do
    render
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
