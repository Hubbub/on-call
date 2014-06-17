require 'icalendar'
require 'sinatra'
require 'twilio-ruby'
require 'json'

FEED_MAP = JSON.parse(ENV["FEED_MAP"])
FALLBACK = ENV["FALLBACK_NUMBER"]
puts "Loaded feed map: #{FEED_MAP.inspect}"

def find_on_call_number(number)
  data = %x{curl -s #{FEED_MAP[number]}}

  cal = Icalendar.parse(data)
  event = cal.first.events.select { |e|
    Date.today >= e.dtstart.value && Date.today < e.dtend.value
  }.first

  if event
    event.location
  else
    puts "WARNING: No number found, using fallback"
    FALLBACK
  end
end

def twiml_response(params, type)
  puts "#{type} received from #{params[:From]} to #{params[:To]}"
  target = find_on_call_number(params[:To])
  puts "Target found: #{target}"

  response = Twilio::TwiML::Response.new do |r|
    yield r, target
  end

  response.text
end

post '/voice' do
  twiml_response(params, "Call") do |r, target|
    r.Say "Your call is being redirected"
    r.Dial do |d|
      d.Number target
    end
  end
end

post '/sms' do
  twiml_response(params, "SMS") do |r, target|
    r.Message(to: target, from: params[:To]) do |m|
      m.Body params[:Body]
    end
  end
end
