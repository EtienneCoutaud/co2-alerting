require 'rest-client'
require 'json'
require 'net/https'
require_relative 'lib/netatmo'
require_relative 'lib/hue'


token = get_token
refresh_token = renew_token(token['refresh_token'])
data = get_netatmo_data(token['access_token'])
noise =  data['body']['devices'][0]['dashboard_data']['Noise'].to_i
co2_value = data['body']['devices'][0]['dashboard_data']['CO2'].to_i
puts 'co2 value: '  + co2_value.to_s
puts 'noise: ' + noise.to_s
state = JSON.parse(File.read('/opt/co2-alerting/state.json'))
if noise > 40
	if co2_value > 1000 && !state['alert']
		hue_on = gets_lights
		selected_hue = select_light_hue(hue_on)
		save_hue_value(selected_hue)
		puts 'selected_hue:'
		puts selected_hue
		color_selected_light 'red'

	else
		state = JSON.parse(File.read('/opt/co2-alerting/state.json'))
		if (co2_value < 500 && state['alert'])
			color_selected_light 'green'
			sleep 20
			puts 'reset hue:'
			reset_hue_light

			File.open("/opt/co2-alerting/state.json","w") do |f|
	  			f.write({"alert" => false}.to_json)
			end
		end
	end
end
