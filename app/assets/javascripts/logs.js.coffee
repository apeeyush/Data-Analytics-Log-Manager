# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  table = $('#logs').dataTable
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#logs').data('source')
    fnServerParams: (aoData) ->
      applicationName = $("#applicationName").val()
      aoData.push
        name: "applicationName"
        value: applicationName

      return

  $("#applicationName").on "change", ->
    table.fnDraw()
    return
