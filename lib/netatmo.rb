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
    'password' => ENV['NETATMO_PASSWORD']
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

def get_device
  uri = URI.parse('https://api.netatmo.net/api/devicelist')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  JSON.parse(Net::HTTP.post_form(uri, {
    'access_token' => get_token['access_token']
  }).body)['body']

end