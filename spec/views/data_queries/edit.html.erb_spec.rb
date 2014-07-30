require 'rails_helper'

RSpec.describe "data_queries/edit", :type => :view do
  before(:each) do
    @data_query = assign(:data_query, DataQuery.create!(
      :content => "",
      :user => nil
    ))
  end

  it "renders the edit data_query form" do
    render

    assert_select "form[action=?][method=?]", data_query_path(@data_query), "post" do

      assert_select "input#data_query_content[name=?]", "data_query[content]"

      assert_select "input#data_query_user_id[name=?]", "data_query[user_id]"
    end
  end
end
