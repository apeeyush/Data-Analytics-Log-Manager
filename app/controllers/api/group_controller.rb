module Api
  class GroupController < ApplicationController
	  after_action :cors_preflight_check
    after_filter :cors_set_access_control_headers

    def index
      request_body = JSON.parse(request.body.read)
      if request_body["group"] != nil
        @groups = Hash.new
        logs=Log.all
        parent = request_body["group"]
        logs.select(parent).group(parent).order(parent).each do |log|
          @groups[log[parent]] = Hash.new
          @groups[log[parent]]["parent_values"] = []
          @groups[log[parent]]["parent_values"] << log[parent]
        end
        # @parent_keys used to store keys (columns) for Parent Table
        @parent_keys = []
        @parent_keys << parent
        # @child_keys used to store keys (columns) for Child Table
        @child_keys = logs.keys_list
        @child_keys = @child_keys - @parent_keys
        if (parent =="username" || parent == "activity" || parent == "application" || parent == "session")
          child_data_groups = logs.group_by { |t| t.send(parent.to_sym) }
        end
        child_data_groups.each do |parent_name, logs|
          child_collection = []
          logs.each do |log|
            child = []
            @child_keys.each do |child_key|
              child << log.value(child_key)
            end
            child_collection << child
          end
          @groups[parent_name]["child_values"] = child_collection
        end
      end
      render "layouts/grouped_data.json.jbuilder"
    end
  end
end