require 'spec_helper'

describe "CreatingLogsTest", :type => :request do
  it "Creates New Log" do
  	data = {
  	  session: "12345", username: 'user1', application: 'Application1', activity: 'Activity1', event: 'Event1', time: '1392862093110', parameters: {parameter1: 'value1', parameter2: 'value2'}, extra_key: 'extra_value'
  	}.to_json
  	post '/api/logs', data, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

  	assert_equal 201, response.status
  	body = JSON.parse(response.body)
    expect(body).to include('session','username','application','activity','event','time','parameters','extras')
    body["session"] == "12345"
    body["username"] == "user1"
    body["application"] == "Application1"
    body["activity"] == "Activity1"
    body["event"] == "Event1"
    body["time"] == "2014-02-20T02:08:13.000Z"
    expect(body["parameters"].size).to eq(2)
    body["parameters"]["parameter1"] == "value1"
    body["parameters"]["parameter2"] == "value2"
    expect(body["extras"].size).to eq(1)
    body["extras"]["extra_key"] == "extra_value"
  end
end