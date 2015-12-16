class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def index
    
    url = URI.parse('http://104.197.214.72:8000/cities-pollutant-timeline?geographical_zone=MXMEX-HGM&dateUnit=hour&now=1
')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    puts res.body


   # @client = create_client
   # @client.update("I'm testing 2!")
    #tuit= client.search("@algo -rt", lang: "es").first.text 
    #new_tuit= tuit.dup.sub! '@algo', '@otro algo'
    #client.update(new_tuit)
  end
private 
  def create_client
    return Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["TW_CONSUMER_KEY"] 
      config.consumer_secret     = ENV["TW_CONSUMER_SECRET"] 
      config.access_token        = ENV["TW_ACCESS_TOKEN"] 
      config.access_token_secret = ENV["TW_ACCESS_TOKEN_SECRET"] 

    end
  end

end
