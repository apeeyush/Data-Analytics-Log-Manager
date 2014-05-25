require 'spec_helper'

describe "CreatingLogsTest" do
  it "Creates New Log" do
  	data = {
  	  session: "12345", user: 'user1', application: 'Application1', activity: 'Activity1', event: 'Event1', time: '1392862093110', parameters: {parameter1: 'value1', parameter2: 'value2'}, extra_key: 'extra_value'
  	}.to_json
  	post '/api/logs', data, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

  	assert_equal 201, response.status
  	body = JSON.parse(response.body)
    body.should include('session')
    body["session"] == "12345"
    body.should include('user')
    body["user"] == "user1"
    body.should include('application')
    body["application"] == "Application1"
    body.should include('activity')
    body["activity"] == "Activity1"
    body.should include('event')
    body["event"] == "Event1"
    body.should include('time')
    body["time"] == "2014-02-20T02:08:13.000Z"
    body.should include('parameters')
    body["parameters"].should have(2).items
    body["parameters"]["parameter1"] == "value1"
    body["parameters"]["parameter2"] == "value2"
    body.should include('extras')
    body["extras"].should have(1).items
    body["extras"]["extra_key"] == "extra_value"
  end
end