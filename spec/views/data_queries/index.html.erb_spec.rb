require 'spec_helper'

RSpec.describe "data_queries/index", :type => :view do
  before(:each) do
    assign(:data_queries, [
      DataQuery.create!(
        :content => "{}",
        :user => nil
      ),
      DataQuery.create!(
        :content => "{}",
        :user => nil
      )
    ])
  end

end
