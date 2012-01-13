require 'parser'
class SearchesController < ApplicationController
  respond_to :json

  def show
  end

  def create
    key = params[:key]
    uri = "http://en.wikipedia.org/wiki/#{key}"
    html = Nokogiri::HTML(open(uri))
    doc = Document.new(html.css("#bodyContent").text)
    result =  doc.find("Earth")
    @options = result.to_hash
    respond_to do |f|
      f.json { render :json => @options}
    end
  end

end
