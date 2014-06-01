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

    private
      # For all responses in this controller, return the CORS access control headers.
      def cors_set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
        headers['Access-Control-Max-Age'] = "1728000"
      end

      # If this is a preflight OPTIONS request, then short-circuit the
      # request, return only the necessary headers and return an empty
      # text/plain.
      def cors_preflight_check
        if request.request_method == "OPTIONS"
          headers['Access-Control-Allow-Origin'] = '*'
          headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
          headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept'
          headers['Access-Control-Max-Age'] = '1728000'
        end
      end
  end
end