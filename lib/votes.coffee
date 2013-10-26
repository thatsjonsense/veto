

@Venues = new Meteor.Collection('venues')
@Votes = new Meteor.Collection('votes')
@Rooms = new Meteor.Collection('rooms')

vote = 
  user: 3483924820 # user id
  venue: 38932849028 # foursquare id
  room: 123322 # room id
  type: 'veto'

room = 
  name: 'dinner tonight'
  users: [38290, 384920, 98092]
  query: 'pizza'
  location: 'Seattle, WA'
