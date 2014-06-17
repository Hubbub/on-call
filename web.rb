require 'sinatra'
require 'twilio-ruby'
require 'json'

post '/voice' do
  target = "+447429498279"
  puts "Call received from #{params[:From]}. Forwarding to #{target}."

  response = Twilio::TwiML::Response.new do |r|
    r.Say "Your call is being redirected"
    r.Dial do |d|
      d.Number target
    end
  end

  response.text
end

post '/sms' do
  target = "+447429498279"
  puts "SMS received from #{params[:From]}. Forwarding to #{target}."

  response = Twilio::TwiML::Response.new do |r|
    r.Message(to: target, from: params[:To]) do |m|
      m.Body params[:Body]
    end
  end

  response.text
end
