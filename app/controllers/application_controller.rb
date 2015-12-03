class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def index
    
    @client = create_client
    @client.update("I'm testing 2!")
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
