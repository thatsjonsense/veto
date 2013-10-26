Template.search.query = ->
  Session.get 'query'

Template.search.loading = ->
  Session.get 'loading'

Template.search.rendered = ->
  $('.card').draggable
    axis: 'x'
    revert: true
    drag: onCardDrag
    stop: onCardDragStop

Template.search.results = ->
  log 'new results'
  results = Session.get 'results'
  votes = Votes.find().fetch()

  vetos = (vote.venue for vote in votes when vote.type == 'veto')

  results_left = _.reject results, (result) -> _.contains vetos, result.venue.id
  Session.set 'loading', false

  return results_left?[...5]



Template.search.events =
  'click .logout': -> Meteor.logout()
  'click .login': -> Meteor.loginWithFacebook()
  'click .searchButton': -> searchVenues()
  'keyup .searchBox': (event) ->
    if event.which == 13
      searchVenues()

searchVenues = ->
  Session.set 'query', $('.searchBox').val()
  Session.set 'loading', true
  Meteor.call 'get_venues', Session.get('query'), 'Seattle, WA', (err, results) ->
    Session.set 'results', results


# Voting
#############
saveVote = (venue, type) ->
  vote = 
    venue: venue
    user: Meteor.userId()
    type: type

  Votes.insert vote

# Dragon drop
##############

THRESHOLD = 250

color = d3.scale.linear()
    .domain([-THRESHOLD,0,THRESHOLD])
    .range(['red','white','green'])
    .clamp(true)

opacity = d3.scale.linear()
  .domain([-THRESHOLD,0,THRESHOLD])
  .range([0.1,1.0,1.0])
  .clamp(true)


onCardDrag = (event, ui) ->
  offset = ui.position.left
  rail = ui.helper.closest('.rail')
  card = ui.helper


  card.css('opacity',opacity offset)

onCardDragStop = (event, ui) ->
  offset = ui.position.left
  rail = ui.helper.closest('.rail')
  card = ui.helper
  venue = card.attr('data-venue-id')

  card.css('opacity',1)

  if offset <  -THRESHOLD
    log 'vetoed'
    saveVote(venue,'veto')

  else if offset > THRESHOLD
    log 'voted'
    saveVote(venue,'upvote')