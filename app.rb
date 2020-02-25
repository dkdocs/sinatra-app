require 'sinatra'
require 'net/http'
require 'openssl'
require "sinatra/json"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class Application < Sinatra::Base
 

  get '/' do
    uri = URI("#{params[:server]}/trusted")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded"
   
    request.set_form_data(
        "server" => params[:server],
        "target_site" => params[:site_name],
        "username" => params[:user_name],
      )

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    json data: response.body, status: response.code
  end

end



