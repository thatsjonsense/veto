
if Meteor.isServer

  Accounts.onCreateUser (opt, user) ->
    if user.services.facebook?
      opt.profile.picture = "http://graph.facebook.com/#{user.services.facebook.id}/picture/?type=large"
    
    user.profile = opt.profile
    return user

  Accounts.loginServiceConfiguration.findOrInsert
    service: 'facebook',
    appId: '170815603107723',
    secret: 'f4b57f457041802e1f0ba76a0d1c44e3'


if Meteor.isClient

  Meteor.loginAnonymously = (callback) ->
    
    Accounts.createUser
      username: 'anonymous' + Random.id() 
      password: 'guest'
      profile:
        name: 'Guest ' + Random.choice('ABCDEFGHIJKLMNOPQRSTUVWXYZ')
        anonymous: true

