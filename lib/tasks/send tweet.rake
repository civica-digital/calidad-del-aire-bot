desc 'send tweet '
task send_tweet: :environment do
	
	url = URI.parse('http://104.197.214.72:8000/cities-pollutant-timeline?geographical_zone=MXMEX-HGM&dateUnit=hour&now=1
	')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    puts JSON.parse(res.body)['pollutants'].sample['timeline'][0]['normalized']
    puts JSON.parse(res.body)['pollutants'].sample['pollutant']
    puts "*************"

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

