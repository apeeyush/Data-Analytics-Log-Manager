require 'spec_helper'

RSpec.describe "data_queries/new", :type => :view do
  before(:each) do
    assign(:data_query, DataQuery.new(
      :content => "",
      :user => nil
    ))
  end

end
