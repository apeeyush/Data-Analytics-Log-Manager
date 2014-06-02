Analytics = undefined
attrs = undefined
attrs_obj = undefined
cases = undefined
controller = undefined
single_case = undefined
window.analyze = ->
  $.ajax
    type: "GET"
    url: "http://log-manager.herokuapp.com/api/logs"
    success: (data) ->
      Analytics.doAnalysis data
      return

  return

window.analyzeFiltered = ->
  data = undefined
  e = undefined
  is_valid = undefined
  data = document.getElementById("body_data").value
  try
    JSON.parse data
    is_valid = true
  catch _error
    e = _error
    is_valid = false
  if is_valid
    $.ajax
      type: "POST"
      url: "http://log-manager.herokuapp.com/api/filter"
      data: data
      success: (data) ->
        Analytics.doAnalysis data
        return

  else
    alert "Invalid JSON"
  return

attrs = []
attrs_obj = []
cases = []
single_case = []
controller = window.parent.DG
Analytics =
  controller: window.parent.DG
  doAnalysis: (data) ->
    i = undefined
    k = undefined
    kParentCollectionName = undefined
    key = undefined
    this_ = undefined
    this_ = this
    kParentCollectionName = "Logs"

    # Computes the list of columns to be sent to CODAP
    # The list is stored in attrs
    # The corresponding formatted list to be passed as argument to CODAP is stored in attrs_obj
    for key of data
      if data.hasOwnProperty(key)
        for k of data[key]
          if $.inArray(k, attrs) <= -1
            attrs.push k
            attrs_obj.push name: k

    # Iterates through all logs and stores values for each case in single_case. 
    # The array is then appended to cases
    for key of data
      if data.hasOwnProperty(key)
        single_case = []
        i = 0
        while i < attrs.length
          if attrs[i] of data[key]
            if typeof data[key][attrs[i]] is "object"
              single_case.push JSON.stringify(data[key][attrs[i]])
            else
              single_case.push data[key][attrs[i]]
          else
            single_case.push ""
          i++
          cases.push single_case

    controller.doCommand
      action: "initGame"
      args:
        name: "DataInteractive"
        dimensions:
          width: 450
          height: 200

    controller.doCommand
      action: "createCollection"
      args:
        name: kParentCollectionName
        attrs: attrs_obj
        log: false

    controller.doCommand
      action: "createCases"
      args:
        collection: "Logs"
        values: cases

    return