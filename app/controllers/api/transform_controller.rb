require 'json'
module Api

  class TransformController < ApplicationController
    after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      request_body = JSON.parse(request.body.read)
      logs = Log.all
      if (request_body["filter"] != nil)
        logs = logs.filter(request_body["filter"])
      end
      if request_body["group"] != nil
      	@parent = request_body["group"]
        if (@parent =="username" || @parent == "activity" || @parent == "application" || @parent == "session")
          @groups = logs.group_by { |t| t.send(@parent.to_sym) }
        else
          # Group by Username by default
          @groups = logs.group_by { |t| t.username }
        end
        # @parent_keys used to store keys (columns) for Parent Table
        @parent_keys = []
        @parent_keys << @parent
        # @child_keys used to store keys (columns) for Child Table
        @child_keys = []
        @child_keys = Log.column_names - %w{id parameters extras}
        @child_keys = @child_keys - @parent_keys
        @groups.each do |parent_name, logs|
          logs.each do |log|
            log.parameters.present? ? @child_keys << log.parameters.keys : @child_keys << []
            log.extras.present? ? @child_keys << log.extras.keys : @child_keys << []
          end
          @child_keys = @child_keys.flatten.uniq
        end
      end
  	end
  end
end