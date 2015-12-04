desc 'send tweet '
task send_tweet: :environment do
	
    @client = create_client
    @client.update("Oye @sinchips recuerdan que ya son las #{Time.now.strftime("%I:%M:%S %z")},hora de ver la calidad del aire http://civica-digital.github.io/calidad-del-aire-webapp")
end

def create_client
    return Twitter::REST::Client.new do |config|
      config.consumer_key        = "#{ ENV["TW_CONSUMER_KEY"] }"
      config.consumer_secret     = "#{ ENV["TW_CONSUMER_SECRET"] }"
      config.access_token        = "#{ ENV["TW_ACCESS_TOKEN"] }"
      config.access_token_secret = "#{ ENV["TW_ACCESS_TOKEN_SECRET"] }" 

    end
end