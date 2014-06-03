module Api
  class GroupController < ApplicationController
	  after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      request_body = JSON.parse(request.body.read)
      if request_body["group"] != nil
      	@parent = request_body["group"]
        if (@parent =="username" || @parent == "activity" || @parent == "application" || @parent == "session")
          @groups = Log.all.group_by { |t| t.send(@parent.to_sym) }
        else
          # Group by Username by default
          @groups = Log.all.group_by { |t| t.username }
        end
      end
    end

  end
end