#!/usr/bin/ruby
#Rest client that uses Vaultoro API to get the balance of the account
#
#Licence: GNU GPL3
#Date: 2, July, 2017                               Davide M. Puggioni

require 'openssl'
require 'net/http'
require 'json'

#Nonce generated from the date bash command
date_nonce = `date +%s`.to_i
puts date_nonce

#Apikey and secret apikey used to generate the HMAC signature for authenticate with Vaultoro
apikey_v = "PutYourApiKeyHere000000000000000"        
secret = "PutYourSecretKeyHere00000000000000000000000="
         

request = "https://api.vaultoro.com/1/balance?nonce=#{date_nonce}&apikey=#{apikey_v}"

puts "Request is: \n" 
puts request

#HMAC signature to be put in the X-Signature header for the GET request
signature = OpenSSL::HMAC.hexdigest('sha256', secret, request)

puts "Signature is: \n"
puts signature

#Requesting the balance: GET request, URI + balance + nonce + apikey + X-Signature generated from secret key
uri = URI("https://api.vaultoro.com/1/balance?nonce=#{date_nonce}&apikey=#{apikey_v}")
req = Net::HTTP::Get.new(uri)
req["X-Signature"] = signature


puts "\nHeaders: \n#{req.to_hash.inspect}"

#Sending the request through HTTPS
res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
  http.request(req)
end

# Status
puts res.code       # => '200'
puts res.message    # => 'OK'
puts res.class.name # => 'HTTPOK'

# Body
puts res.body






