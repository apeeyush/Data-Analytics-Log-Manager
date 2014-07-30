require 'rails_helper'

RSpec.describe "data_queries/new", :type => :view do
  before(:each) do
    assign(:data_query, DataQuery.new(
      :content => "",
      :user => nil
    ))
  end

  it "renders new data_query form" do
    render

    assert_select "form[action=?][method=?]", data_queries_path, "post" do

      assert_select "input#data_query_content[name=?]", "data_query[content]"

      assert_select "input#data_query_user_id[name=?]", "data_query[user_id]"
    end
  end
end
