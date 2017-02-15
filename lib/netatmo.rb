def get_token
  uri = URI.parse("https://api.netatmo.net/oauth2/token")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  JSON.parse Net::HTTP.post_form(uri, {
    'grant_type' => 'password',
    'client_id' => NETATMO_CLIENT_ID,
    'client_secret' => NETATMO_SECRET,
    'username' => 'e.coutaud@gmail.com',
    'password' => 'Len9vetlen#'
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
    'client_id' => config['client_id'],
    'client_secret' => config['client_secret']}).body
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