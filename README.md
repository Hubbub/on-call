# On Call

This is a small TwiML application to route phone calls to the right person.

## Setup

We deployed this to Heroku, and then pointed it at the iCal feed for our developer on call rota. In the calendar
set the location field on an event to a phone number, and any calls or text messages to the number pointed at this
will be forwarded. You can also set multiple numbers if you have more than one team.

```
heroku create our-on-call
heroku config:set FEED_MAP='{ "+4412345677": "https://example.org/our/rota.ical" }'
git push heroku master
```

You'll then need to point a Twilio number at the application:

Voice: https://our-on-call.herokuapp.com/voice
Message: https://our-on-call.herokuapp.com/sms

And you're done!
