require 'spec_helper'

describe "CreatingMultipleLogsTest", :type => :request do
  it "Creates Multiple Logs when passed an array of Logs" do
  	data = [
      {
  	    session: "session1", username: 'user1', application: 'Application1', activity: 'Activity1', event: 'Event1', time: '1392862093110', parameters: {parameter1: 'value1', parameter2: 'value2'}, extra_key: 'extra_value'
  	  },
      {
        session: "session2", username: 'user2', application: 'Application2', activity: 'Activity2', event: 'Event2', time: '1392862093110', parameters: {parameter1: 'value1', parameter2: 'value2'}, extra_key1: 'extra_value1'
      }
    ].to_json
  	post '/api/logs', data, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

  	assert_equal 201, response.status
  	body = JSON.parse(response.body)
    expect(body[0]).to include('session','username','application','activity','event','time','parameters','extras')
    expect(body[1]).to include('session','username','application','activity','event','time','parameters','extras')

    body[0]["session"] == "session1"
    body[0]["username"] == "user1"
    body[0]["application"] == "Application1"
    body[0]["activity"] == "Activity1"
    body[0]["event"] == "Event1"
    body[0]["time"] == "2014-02-20T02:08:13.000Z"
    expect(body[0]["parameters"].size).to eq(2)
    body[0]["parameters"]["parameter1"] == "value1"
    body[0]["parameters"]["parameter2"] == "value2"
    expect(body[0]["extras"].size).to eq(1)
    body[0]["extras"]["extra_key"] == "extra_value"

    body[1]["session"] == "session2"
    body[1]["username"] == "user2"
    body[1]["application"] == "Application2"
    body[1]["activity"] == "Activity2"
    body[1]["event"] == "Event2"
    body[1]["time"] == "2014-02-20T02:08:13.000Z"
    expect(body[1]["parameters"].size).to eq(2)
    body[1]["parameters"]["parameter1"] == "value1"
    body[1]["parameters"]["parameter2"] == "value2"
    expect(body[1]["extras"].size).to eq(1)
    body[1]["extras"]["extra_key1"] == "extra_value1"

  end
end