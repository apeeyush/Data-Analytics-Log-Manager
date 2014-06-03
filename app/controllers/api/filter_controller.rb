module Api
  require 'json'

  class FilterController < ApplicationController
  	after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      request_body = JSON.parse(request.body.read)
      logs = Log.all
      if (request_body["filter"] != nil)
        filter = request_body["filter"]
        if (filter["application"] != nil && !filter["application"].empty?)
        	logs = logs.where({application: filter["application"]})
        end
        if (filter["activity"] != nil && !filter["activity"].empty?)
        	logs = logs.where({activity: filter["activity"]})
        end
        if (filter["username"] != nil && !filter["username"].empty?)
        	logs = logs.where({username: filter["username"]})
        end
        if (filter["event"] != nil && !filter["event"].empty?)
        	logs = logs.where({event: filter["event"]})
        end
        if (filter["time"] != nil && !filter["time"].empty?)
        	logs = logs.where("time >= :start_time AND time <= :end_time",{start_time: filter["time"][0], end_time: filter["time"][1]})
        end
        if (filter["parameters"] != nil && filter["parameters"]["keys"] != nil && !filter["parameters"]["keys"].empty?)
        	keys = filter["parameters"]["keys"]
        	keys.each do |key|
        	  logs = logs.where("parameters ? :key", key: key)
        	end
        end
        if (filter["parameters"] != nil && filter["parameters"]["pairs"] != nil && !filter["parameters"]["pairs"].empty?)
        	pairs = filter["parameters"]["pairs"]
        	pairs.each do |key, value|
        	  logs = logs.where("parameters @> (:key => :value)", key: key, value: value)
        	end
        end
        if (filter["extras"] != nil && filter["extras"]["keys"] != nil && !filter["extras"]["keys"].empty?)
        	keys = filter["extras"]["keys"]
        	keys.each do |key|
        	  logs = logs.where("extras ? :key", key: key)
        	end
        end
        if (filter["extras"] != nil && filter["extras"]["pairs"] != nil && !filter["extras"]["pairs"].empty?)
        	pairs = filter["extras"]["pairs"]
        	pairs.each do | key, value|
        	  logs = logs.where("extras @> (:key => :value)", key: key, value: value)
        	end
        end
      end
	    if logs != nil
      	@logs = logs
      else
        render status: :no_content
      end
    end

  end
end