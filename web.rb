require 'sinatra'
require 'twilio-ruby'

post '/voice' do
  puts "Got a call for #{params[:group]}"
end

post '/sms' do
  puts "Got an SMS for #{params[:group]}"
end
