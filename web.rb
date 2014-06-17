require 'icalendar'
require 'sinatra'
require 'twilio-ruby'
require 'json'

FEED_MAP = JSON.parse(ENV["FEED_MAP"])
puts "Loaded feed map: #{FEED_MAP.inspect}"

def find_on_call_number(number)
  data = %x{curl -s #{FEED_MAP[number]}}

  cal = Icalendar.parse(data)
  event = cal.first.events.select { |e|
    Date.today >= e.dtstart.value && Date.today < e.dtend.value
  }.first

  event.location
end

post '/voice' do
  puts "Call received from #{params[:From]} to #{params[:To]}"
  target = find_on_call_number(params[:To])
  puts "Target found: #{target}"

  response = Twilio::TwiML::Response.new do |r|
    r.Say "Your call is being redirected"
    r.Dial do |d|
      d.Number target
    end
  end

  response.text
end

post '/sms' do
  puts "SMS received from #{params[:From]} to #{params[:To]}"
  target = find_on_call_number(params[:To])
  puts "Target found: #{target}"

  response = Twilio::TwiML::Response.new do |r|
    r.Message(to: target, from: params[:To]) do |m|
      m.Body params[:Body]
    end
  end

  response.text
end
