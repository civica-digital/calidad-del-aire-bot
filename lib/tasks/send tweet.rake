require 'net/http'
desc 'send tweet '

task send_tweet: :environment do
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
    #save the pollutant for get the same value when i get value & name
    pollutant=JSON.parse(res.body)['pollutants'].sample
    value= pollutant['timeline'][0]['normalized'].to_s
    name= pollutant['pollutant']
    
    if ( value != "nan")
      return  get_ramdon_message(value)
	else
		get_data
	end
end

def get_ramdon_message (val)

  ary = ["Según la OMS la calidad del aire es:#{get_quality(val)} ", "En estos momentos la calidad del aire es #{get_quality(val) }", "Se detecta como #{get_quality(val)} la calidad del aire según la OMS"] 
  return ary.sample
end

def get_quality(value)
    return (value.to_f>1) ? "encima" : "regular";
end

def create_client
    return Twitter::REST::Client.new do |config|
      config.consumer_key        = "#{ ENV["TW_CONSUMER_KEY"] }"
      config.consumer_secret     = "#{ ENV["TW_CONSUMER_SECRET"] }"
      config.access_token        = "#{ ENV["TW_ACCESS_TOKEN"] }"
      config.access_token_secret = "#{ ENV["TW_ACCESS_TOKEN_SECRET"] }" 

    end
end

