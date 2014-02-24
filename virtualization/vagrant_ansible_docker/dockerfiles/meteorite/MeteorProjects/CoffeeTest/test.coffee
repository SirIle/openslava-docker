if Meteor.isClient
  Template.hello.greeting = ->
    "Welcome to meteor"

  Template.hello.events = "click input": ->
    console.log "You pressed the button"

if Meteor.isServer
  Meteor.startup ->
    # code to run on server at startup
    