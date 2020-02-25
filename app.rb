require 'sinatra'
require 'net/http'
require 'uri'
require 'openssl'
require "sinatra/json"
require 'pry-rails'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class Application < Sinatra::Base
 

  get '/' do
    uri = URI("#{params[:server]}/trusted")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/x-www-form-urlencoded"
    request["Origin"] = "10.55.97.212"
    request["Upgrade-Insecure-Requests"] = "1"
    request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
   
    request.set_form_data(
        "server" => params[:server],
        "target_site" => params[:site_name],
        "username" => params[:username],
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



