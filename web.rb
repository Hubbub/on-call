require 'icalendar'
require 'sinatra'
require 'twilio-ruby'
require 'json'

def find_on_call_number
  feed = 'https://www.google.com/calendar/ical/hubbub.co.uk_0figeu9ktc7v6vsl4rc2ggg7bs%40group.calendar.google.com/public/basic.ics'
  data = %x{curl -s #{feed}}

  cal = Icalendar.parse(data)
  event = cal.first.events.select { |e|
    Date.today >= e.dtstart.value && Date.today < e.dtend.value
  }.first

  event.location
end

post '/voice' do
  target = find_on_call_number
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
  target = find_on_call_number
  puts "SMS received from #{params[:From]}. Forwarding to #{target}."

  response = Twilio::TwiML::Response.new do |r|
    r.Message(to: target, from: params[:To]) do |m|
      m.Body params[:Body]
    end
  end

  response.text
end
