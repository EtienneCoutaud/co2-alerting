def get_hue_url
	data = JSON.parse(File.read('/opt/co2-alerting/config.json'))
	data['HUE_BRIDGE'] + data['HUE_TOKEN']
end

def gets_lights
	lights = RestClient.get get_hue_url + '/lights'
	JSON.parse(lights)
	#json_lights.delete_if{ |id, value| value['state']['on'] == false }
end

def select_light_hue hue_on
	Hash[hue_on.to_a.sample(1)]
end

def color_selected_light color
	state = JSON.parse(File.read('/opt/co2-alerting/state.json'))
	response = RestClient.put get_hue_url + '/lights/' +state['id'] + '/state', JSON.parse(File.read("/opt/co2-alerting/color/#{color}.json")).to_json
	puts response
end

def save_hue_value light
	if !light.empty?
		key, value = light.first
		#json = {"alert" => true, "hue_id" => key, "sat" => value['state']['sat'], "bri" =>  value['state']['bri'], "hue" => value['state']['hue'], "cm" => value['state']['colormode']}
		json = {"alert" => true, "id" => key, "value" => value}
		File.open("/opt/co2-alerting/state.json","w") do |f|
  			f.write(json.to_json)
		end
	end
end

def reset_hue_light
	state = JSON.parse(File.read('/opt/co2-alerting/state.json'))
	#value = {"on" => true, "sat" => state['sat'].to_i, "bri" => state['bri'].to_i, "hue" => state['hue'].to_i, "alert" => "none", "colormode" => state['cm']}
	state['value']['state']['alert'] = 'none'
	puts state
	response =RestClient.put get_hue_url + '/lights/' + state['id'] + '/state', state['value']['state'].to_json
	puts response
end
