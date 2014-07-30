require 'spec_helper'

RSpec.describe "data_queries/show", :type => :view do
  before(:each) do
    @data_query = assign(:data_query, DataQuery.create!(
      :content => "",
      :user => nil
    ))
  end

end
