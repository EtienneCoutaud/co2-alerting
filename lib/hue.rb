def gets_lights_on
	lights = RestClient.get ENV['HUE_BRIDGE'] + ENV['HUE_TOKEN'] + '/lights'
	json_lights = JSON.parse(lights)

	json_lights.delete_if{ |id, value| value['state']['on'] == false }
end

def select_light_hue hue_on
	Hash[hue_on.to_a.sample(1)]
end

def color_selected_light light
	key, value = light.first
	RestClient.put ENV['HUE_BRIDGE'] + ENV['HUE_TOKEN'] + '/lights/' + key.to_s + '/state', '{"on": true, "sat":254, "bri":50,"hue": 400, "alert": "lselect"}'
end

def save_hue_value light
	key, value = light.first
	ENV['HUE_ID'] = key
	ENV['SAT'] = value['state']['sat'].to_s
	ENV['BRI'] = value['state']['bri'].to_s
	ENV['HUE'] = value['state']['hue'].to_s
	ENV['CM']  = value['state']['colormode'].to_s
end

def reset_hue_light
	sat = 
	value = {"on" => true, "sat" => ENV['SAT'].to_i, "bri" => ENV['BRI'].to_i, "hue" => ENV['HUE'].to_i, "alert" => "none", "colormode" => ENV['CM']}
	puts JSON.generate(value)
	response =RestClient.put ENV['HUE_BRIDGE'] + ENV['HUE_TOKEN'] + '/lights/' + ENV['HUE_ID'] + '/state', JSON.generate(value)
	puts response
end