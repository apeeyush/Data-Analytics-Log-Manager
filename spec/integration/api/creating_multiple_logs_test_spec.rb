require 'spec_helper'

describe "CreatingMultipleLogsTest" do
  it "Creates Multiple Logs when passed an array of Logs" do
  	data = [
      {
  	    session: "session1", user: 'user1', application: 'Application1', activity: 'Activity1', event: 'Event1', time: '1392862093110', parameters: {parameter1: 'value1', parameter2: 'value2'}, extra_key: 'extra_value'
  	  },
      {
        session: "session2", user: 'user2', application: 'Application2', activity: 'Activity2', event: 'Event2', time: '1392862093110', parameters: {parameter1: 'value1', parameter2: 'value2'}, extra_key1: 'extra_value1'
      }
    ].to_json
  	post '/api/logs', data, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

  	assert_equal 201, response.status
  	body = JSON.parse(response.body)
    body[0].should include('session','user','application','activity','event','time','parameters','extras')
    body[1].should include('session','user','application','activity','event','time','parameters','extras')

    body[0]["session"] == "session1"
    body[0]["user"] == "user1"
    body[0]["application"] == "Application1"
    body[0]["activity"] == "Activity1"
    body[0]["event"] == "Event1"
    body[0]["time"] == "2014-02-20T02:08:13.000Z"
    body[0]["parameters"].should have(2).items
    body[0]["parameters"]["parameter1"] == "value1"
    body[0]["parameters"]["parameter2"] == "value2"
    body[0]["extras"].should have(1).items
    body[0]["extras"]["extra_key"] == "extra_value"

    body[1]["session"] == "session2"
    body[1]["user"] == "user2"
    body[1]["application"] == "Application2"
    body[1]["activity"] == "Activity2"
    body[1]["event"] == "Event2"
    body[1]["time"] == "2014-02-20T02:08:13.000Z"
    body[1]["parameters"].should have(2).items
    body[1]["parameters"]["parameter1"] == "value1"
    body[1]["parameters"]["parameter2"] == "value2"
    body[1]["extras"].should have(1).items
    body[1]["extras"]["extra_key1"] == "extra_value1"

  end
end