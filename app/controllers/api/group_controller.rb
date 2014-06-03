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

        @parent_keys = []
        @parent_keys << @parent

        @child_keys = []
        @child_keys = Log.column_names - %w{id parameters extras}
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