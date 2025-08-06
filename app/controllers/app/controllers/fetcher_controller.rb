require 'net/http'
require 'uri'

class FetcherController < ApplicationController
  def fetch
    url = params[:target_url]
    uri = URI.parse(url)
    
    # SSRF: External request based on unvalidated user input
    result = Net::HTTP.get(uri)

    render plain: result
  rescue StandardError => e
    render plain: "Error: #{e.message}", status: 500
  end
end
