require 'net/http'
desc 'send tweet '

task send_tweet: :environment do
	
	get_data
    @client = create_client
    @client.update("#{Time.now.strftime("%I:%M:%S %z")} #{get_data} +info http://civica-digital.github.io/calidad-del-aire-webapp")
end
def get_data

	url = URI.parse('http://104.197.214.72:8000/cities-pollutant-timeline?geographical_zone=MXMEX-HGM&dateUnit=hour&now=1
	')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    value= JSON.parse(res.body)['pollutants'].sample['timeline'][0]['normalized'].to_s
    name= JSON.parse(res.body)['pollutants'].sample['pollutant']
    if ( value != "nan")
	    puts value
	    puts name
	    puts "*************"

	    return "El contaminante #{name} tiene un valor de #{value} "
	else
		get_data
	end
end
def create_client
    return Twitter::REST::Client.new do |config|
      config.consumer_key        = "#{ ENV["TW_CONSUMER_KEY"] }"
      config.consumer_secret     = "#{ ENV["TW_CONSUMER_SECRET"] }"
      config.access_token        = "#{ ENV["TW_ACCESS_TOKEN"] }"
      config.access_token_secret = "#{ ENV["TW_ACCESS_TOKEN_SECRET"] }" 

    end
end

