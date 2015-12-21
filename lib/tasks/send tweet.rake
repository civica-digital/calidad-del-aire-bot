require 'net/http'
desc 'send tweet '

task send_tweet: :environment do
	  @client = create_client
    t=Time.now 
    time=t-21600
    puts time
    @client.update("#{time.strftime("%I:%M:%S")} #{get_data} +info http://civica-digital.github.io/calidad-del-aire-webapp")
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
      return  get_ramdon_message(value,name)
	else
		get_data
	end
end
def dictionary(name)
  if name== "PM10" || name == "PM25"
    message="Polvo en el aire"
  elsif name=="O3"
    message="Ozono"
  elsif name=="NO" || name == "SO" || name == "SO2" || name=="NO2"
    message ="Producto de la quema de combustibles"
  end
end

def get_ramdon_message (val,name)
  ary = ["Según la OMS la calidad del aire esta:#{get_quality(val)} por #{dictionary(name)} ", "En estos momentos la calidad del aire esta #{get_quality(val)} por #{dictionary(name)}. OMS", "Se detecta como #{get_quality(val)} la calidad del aire por #{dictionary(name)} según la OMS"] 
  return ary.sample
end

def get_quality(value)
    return (value.to_f>1) ? "por encima del estandar" : "regular al estándar";
end

def create_client
    return Twitter::REST::Client.new do |config|
      config.consumer_key        = "#{ ENV["TW_CONSUMER_KEY"] }"
      config.consumer_secret     = "#{ ENV["TW_CONSUMER_SECRET"] }"
      config.access_token        = "#{ ENV["TW_ACCESS_TOKEN"] }"
      config.access_token_secret = "#{ ENV["TW_ACCESS_TOKEN_SECRET"] }" 

    end
end

