require 'json'
module Api
  class DocumentController < ApplicationController

    before_action :authenticate_user!

  	def all
  	  documents = Document.all
  	  docs_list = []
  	  documents.each do |document|
  	  	doc_details = Hash.new
  	  	doc_details["name"] = document.name
  	  	doc_details["id"] = document.id
  	  	doc_details["_permissions"] = 0
  	  	docs_list << doc_details
  	  end
	    render json: docs_list, status: 200
  	end

  	def open
  	  id = params[:recordid]
  	  doc = Document.find(id)
  	  if doc != nil
  	  	render json: doc.data, status: 200
  	  else
  	  	render json: {}, status: :bad_request
  	  end
  	end

  	def save
  	  name = params[:recordname]
      request_body = request.body.read
      if name != nil && request_body != nil
  	    doc = Document.new
  	    doc.name = name
    	  doc.data = JSON.parse(request_body)
    	  if doc.save
  	    	render json: {}, status: 200
  	    else
  	  	  render json: {}, status: :unprocessable_entity
  	    end
      else
        render json: {}, status: :bad_request
      end
  	end
  end
end