require 'sinatra'
require 'twilio-ruby'

post '/voice' do
  puts "Got a call"
end

post '/sms' do
  puts "Got an SMS"
end
