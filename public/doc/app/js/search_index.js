var search_data = {"index":{"searchIndex":["addmeasure","addsyntheticdata","admin","analyticshelper","api","authcontroller","documentcontroller","grouptransformcontroller","iscontroller","logscontroller","tabletransformcontroller","application","applicationcontroller","applicationhelper","datainteractivecontroller","datainteractivehelper","dataqueriescontroller","dataquerieshelper","dataquery","document","documentscontroller","documentshelper","log","logscontroller","logsdatatable","logshelper","object","pagescontroller","pageshelper","transformdata","user","about()","all()","as_json()","bootstrap_class_for()","calculate_count()","calculate_sum()","calculate_values()","column_lists()","compute()","cors_preflight_check()","cors_set_access_control_headers()","create()","create()","create()","destroy()","destroy()","edit()","edit()","ensure_params_exist()","explore()","filter()","filter_having_keys()","get_explore_data()","index()","index()","index()","index()","index()","index()","index()","invalid_login_attempt()","keys_list()","login()","main()","new()","new()","new()","open()","options()","satisfies_conditions()","save()","show()","show()","transform_child_data()","update()","update()","update_value()","value()","readme"],"longSearchIndex":["addmeasure","addsyntheticdata","admin","analyticshelper","api","api::authcontroller","api::documentcontroller","api::grouptransformcontroller","api::iscontroller","api::logscontroller","api::tabletransformcontroller","application","applicationcontroller","applicationhelper","datainteractivecontroller","datainteractivehelper","dataqueriescontroller","dataquerieshelper","dataquery","document","documentscontroller","documentshelper","log","logscontroller","logsdatatable","logshelper","object","pagescontroller","pageshelper","transformdata","user","pagescontroller#about()","api::documentcontroller#all()","logsdatatable#as_json()","applicationhelper#bootstrap_class_for()","addmeasure::calculate_count()","addmeasure::calculate_sum()","addmeasure::calculate_values()","log::column_lists()","addsyntheticdata::compute()","applicationcontroller#cors_preflight_check()","applicationcontroller#cors_set_access_control_headers()","api::logscontroller#create()","dataqueriescontroller#create()","documentscontroller#create()","dataqueriescontroller#destroy()","documentscontroller#destroy()","dataqueriescontroller#edit()","documentscontroller#edit()","api::authcontroller#ensure_params_exist()","pagescontroller#explore()","log::filter()","log::filter_having_keys()","pagescontroller#get_explore_data()","api::grouptransformcontroller#index()","api::iscontroller#index()","api::tabletransformcontroller#index()","datainteractivecontroller#index()","dataqueriescontroller#index()","documentscontroller#index()","logscontroller#index()","api::authcontroller#invalid_login_attempt()","log::keys_list()","api::authcontroller#login()","pagescontroller#main()","dataqueriescontroller#new()","documentscontroller#new()","logsdatatable::new()","api::documentcontroller#open()","api::logscontroller#options()","log#satisfies_conditions()","api::documentcontroller#save()","dataqueriescontroller#show()","documentscontroller#show()","transformdata::transform_child_data()","dataqueriescontroller#update()","documentscontroller#update()","log#update_value()","log#value()",""],"info":[["AddMeasure","","AddMeasure.html","",""],["AddSyntheticData","","AddSyntheticData.html","",""],["Admin","","Admin.html","","<p>Schema Information\n<p>Table name: admins\n\n<pre>id                     :integer          not null, primary key\nemail ...</pre>\n"],["AnalyticsHelper","","AnalyticsHelper.html","",""],["Api","","Api.html","",""],["Api::AuthController","","Api/AuthController.html","",""],["Api::DocumentController","","Api/DocumentController.html","",""],["Api::GroupTransformController","","Api/GroupTransformController.html","",""],["Api::IsController","","Api/IsController.html","","<p>This controller was added to use import some Inquiry Space Data to the Log\nManager. The data did not …\n"],["Api::LogsController","","Api/LogsController.html","",""],["Api::TableTransformController","","Api/TableTransformController.html","",""],["Application","","Application.html","","<p>Schema Information\n<p>Table name: applications\n\n<pre>id         :integer          not null, primary key\nname    ...</pre>\n"],["ApplicationController","","ApplicationController.html","",""],["ApplicationHelper","","ApplicationHelper.html","",""],["DataInteractiveController","","DataInteractiveController.html","",""],["DataInteractiveHelper","","DataInteractiveHelper.html","",""],["DataQueriesController","","DataQueriesController.html","",""],["DataQueriesHelper","","DataQueriesHelper.html","",""],["DataQuery","","DataQuery.html","",""],["Document","","Document.html","","<p>Schema Information\n<p>Table name: documents\n\n<pre>id         :integer          not null, primary key\nname       ...</pre>\n"],["DocumentsController","","DocumentsController.html","",""],["DocumentsHelper","","DocumentsHelper.html","",""],["Log","","Log.html","","<p>Schema Information\n<p>Table name: logs\n\n<pre>id          :integer          not null, primary key\nsession     :string(255) ...</pre>\n"],["LogsController","","LogsController.html","",""],["LogsDatatable","","LogsDatatable.html","",""],["LogsHelper","","LogsHelper.html","",""],["Object","","Object.html","",""],["PagesController","","PagesController.html","",""],["PagesHelper","","PagesHelper.html","",""],["TransformData","","TransformData.html","",""],["User","","User.html","","<p>Schema Information\n<p>Table name: users\n\n<pre>id                     :integer          not null, primary key\nemail ...</pre>\n"],["about","PagesController","PagesController.html#method-i-about","()",""],["all","Api::DocumentController","Api/DocumentController.html#method-i-all","()",""],["as_json","LogsDatatable","LogsDatatable.html#method-i-as_json","(options = {})",""],["bootstrap_class_for","ApplicationHelper","ApplicationHelper.html#method-i-bootstrap_class_for","(flash_type)","<p>Mapping from devise flast type to corresponding bootstrap class\n"],["calculate_count","AddMeasure","AddMeasure.html#method-c-calculate_count","(measure_details, logs, parent, parents_list)","<p>Calculates count of number of logs (after filtering) for each parent in\nparents_list grouped by parent …\n"],["calculate_sum","AddMeasure","AddMeasure.html#method-c-calculate_sum","(measure_details, logs, parent, parents_list)","<p>Calculates sum of values of logs (after filtering) for each parent in\nparents_list grouped by parent …\n"],["calculate_values","AddMeasure","AddMeasure.html#method-c-calculate_values","(measure_details, logs, parent, parents_list)","<p>Returns a hash with parent_name as key and first log&#39;s value for each\ngroup as value\n"],["column_lists","Log","Log.html#method-c-column_lists","()","<p>Returns a hash with key as column_type and value as lists of names of that\ncolumn_type\n<p>Example:\n\n<pre>Log.column_lists ...</pre>\n"],["compute","AddSyntheticData","AddSyntheticData.html#method-c-compute","(logs, parent, synthetic_data, parents_list, child_keys)","<p>Calculates the synthetic data to be added to the child table Returns a list\nof computed logs\n"],["cors_preflight_check","ApplicationController","ApplicationController.html#method-i-cors_preflight_check","()","<p>If this is a preflight OPTIONS request, then short-circuit the request,\nreturn only the necessary headers …\n"],["cors_set_access_control_headers","ApplicationController","ApplicationController.html#method-i-cors_set_access_control_headers","()","<p>For all responses in this controller, return the CORS access control\nheaders.\n"],["create","Api::LogsController","Api/LogsController.html#method-i-create","()","<p>Receive Post request and store logs from request body\n"],["create","DataQueriesController","DataQueriesController.html#method-i-create","()","<p>POST /data_queries POST /data_queries.json\n"],["create","DocumentsController","DocumentsController.html#method-i-create","()","<p>POST /documents POST /documents.json\n"],["destroy","DataQueriesController","DataQueriesController.html#method-i-destroy","()","<p>DELETE /data_queries/1 DELETE /data_queries/1.json\n"],["destroy","DocumentsController","DocumentsController.html#method-i-destroy","()","<p>DELETE /documents/1 DELETE /documents/1.json\n"],["edit","DataQueriesController","DataQueriesController.html#method-i-edit","()","<p>GET /data_queries/1/edit\n"],["edit","DocumentsController","DocumentsController.html#method-i-edit","()","<p>GET /documents/1/edit\n"],["ensure_params_exist","Api::AuthController","Api/AuthController.html#method-i-ensure_params_exist","()",""],["explore","PagesController","PagesController.html#method-i-explore","()",""],["filter","Log","Log.html#method-c-filter","(filter_list)","<p>Filters data having specified values/range for the keys\n<p>Example JSON Body:\n\n<pre>[\n  {\n    &quot;key&quot; : &quot;username&quot;, ...</pre>\n"],["filter_having_keys","Log","Log.html#method-c-filter_having_keys","(filter)","<p>Filters data having specified keys\n<p>Example JSON Body:\n\n<pre>&quot;keys&quot; : {\n  &quot;list&quot; : [&quot;event&quot;,&quot;color&quot;]\n}</pre>\n"],["get_explore_data","PagesController","PagesController.html#method-i-get_explore_data","()",""],["index","Api::GroupTransformController","Api/GroupTransformController.html#method-i-index","()",""],["index","Api::IsController","Api/IsController.html#method-i-index","()",""],["index","Api::TableTransformController","Api/TableTransformController.html#method-i-index","()",""],["index","DataInteractiveController","DataInteractiveController.html#method-i-index","()",""],["index","DataQueriesController","DataQueriesController.html#method-i-index","()","<p>GET /data_queries GET /data_queries.json\n"],["index","DocumentsController","DocumentsController.html#method-i-index","()","<p>GET /documents GET /documents.json\n"],["index","LogsController","LogsController.html#method-i-index","()","<p>GET /logs GET /logs.json\n"],["invalid_login_attempt","Api::AuthController","Api/AuthController.html#method-i-invalid_login_attempt","()",""],["keys_list","Log","Log.html#method-c-keys_list","()","<p>Returns the list of keys for logs except id\n<p>Example:\n\n<pre>Log.keys_list</pre>\n"],["login","Api::AuthController","Api/AuthController.html#method-i-login","()",""],["main","PagesController","PagesController.html#method-i-main","()",""],["new","DataQueriesController","DataQueriesController.html#method-i-new","()","<p>GET /data_queries/new\n"],["new","DocumentsController","DocumentsController.html#method-i-new","()","<p>GET /documents/new\n"],["new","LogsDatatable","LogsDatatable.html#method-c-new","(view, application_list)",""],["open","Api::DocumentController","Api/DocumentController.html#method-i-open","()",""],["options","Api::LogsController","Api/LogsController.html#method-i-options","()","<p>Send empty text for options request\n"],["satisfies_conditions","Log","Log.html#method-i-satisfies_conditions","(conditions)",""],["save","Api::DocumentController","Api/DocumentController.html#method-i-save","()",""],["show","DataQueriesController","DataQueriesController.html#method-i-show","()","<p>GET /data_queries/1 GET /data_queries/1.json\n"],["show","DocumentsController","DocumentsController.html#method-i-show","()","<p>GET /documents/1 GET /documents/1.json\n"],["transform_child_data","TransformData","TransformData.html#method-c-transform_child_data","(logs, parent_name, child_keys)","<p>Reformats children logs and returns array of array where internal array\ncontains  values for a log in …\n"],["update","DataQueriesController","DataQueriesController.html#method-i-update","()","<p>PATCH/PUT /data_queries/1 PATCH/PUT /data_queries/1.json\n"],["update","DocumentsController","DocumentsController.html#method-i-update","()","<p>PATCH/PUT /documents/1 PATCH/PUT /documents/1.json\n"],["update_value","Log","Log.html#method-i-update_value","(key, value)",""],["value","Log","Log.html#method-i-value","(key)","<p>Takes a key, returns the corresponding value if key is a column name,\notherwise  searches parameters …\n"],["README","","README_rdoc.html","","<p>Data Analytics Log Manager\n<p><img\nsrc=“https://travis-ci.org/apeeyush/Data-Analytics-Log-Manager.svg?branch=master”\n…\n"]]}}