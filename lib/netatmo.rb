def get_token
  uri = URI.parse("https://api.netatmo.net/oauth2/token")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  JSON.parse Net::HTTP.post_form(uri, {
    'grant_type' => 'password',
    'client_id' => ENV['NETATMO_CLIENT_ID'],
    'client_secret' => ENV['NETATMO_SECRET'],
    'username' => ENV['NETATMO_MAIL'],
    'password' => ENV['NETATMO_PASSWORD'],
    'scope' => 'read_homecoach'
  }).body
end

def renew_token(refresh_token)
  uri = URI.parse("https://api.netatmo.net/oauth2/token")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  JSON.parse Net::HTTP.post_form(uri, {
    'grant_type' => 'refresh_token',
    'refresh_token' => refresh_token,
    'client_id' => ENV['NETATMO_CLIENT_ID'],
    'client_secret' => ENV['NETATMO_SECRET']}).body
end

def get_data(token)
  uri = URI.parse("https://api.netatmo.com/api/gethomecoachsdata")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  JSON.parse Net::HTTP.post_form(uri, {
    'access_token' => token,
    'device_id' => ENV['NETATMO_DEVICE_ID']}).body
end