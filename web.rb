require 'sinatra'
require 'twilio-ruby'
require 'json'

post '/voice' do
  puts "Got a call"
end

post '/sms' do
  $stderr.puts params.to_json

  response = Twilio::TwiML::Response.new do |r|
    r.Message(to: "+447429498279", from: params[:To]) do |m|
      m.Body params[:Body]
    end
  end
  $stderr.puts response.text

  response.text
end
