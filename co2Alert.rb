require 'rest-client'
require 'json'
require 'net/https'
require_relative 'lib/netatmo'
require_relative 'lib/hue'



token = get_token
refresh_token = renew_token(token['refresh_token'])
data = get_data(refresh_token['access_token'])

#co2_value = data['body']['devices'][0]['dashboard_data']['CO2'].to_i
co2_value = 1001

if co2_value > 1000

	hue_on = gets_lights_on
	selected_hue = select_light_hue(hue_on)
	save_hue_value(selected_hue)
	color_selected_light(selected_hue)
	puts 'SELECTED HUE ->'
	puts selected_hue
	sleep 20
	puts 'RESET HUE ->'
	reset_hue_light
end
