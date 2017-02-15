require 'rest-client'
require 'json'
require 'net/https'
require_relative 'lib/netatmo'


puts get_token


def gets_lights area
	lights = RestClient.get HUE_BRIDGE + HUE_TOKEN + '/groups'
	json_lights = JSON.parse(lights)

	ids = []
	for (key, value) in json_lights do 
		if (value['name'] == area)
			ids = value['lights']
		end
	end
	ids
end


def switch_light state, color
	i = 0
	id_chambre = gets_lights 'Chambre'

	while i < 65535  do
   		puts '>> i value ' + i.to_s
   		for id in id_chambre
			RestClient.put HUE_BRIDGE + HUE_TOKEN + '/lights/' + id.to_s + '/state', '{"on":' + state.to_s + ', "sat":254, "bri":150,"hue":' + i.to_s + '}'
			sleep 1
		end
		i += 5000
	end
end

# puts gets_lights 'Chambre'

