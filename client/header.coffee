Template.header.events
    'click .logout': -> Meteor.logout()
    'click .login': -> Meteor.loginWithFacebook()
