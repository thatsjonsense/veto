
# Anonymous users
#################

Meteor.startup ->
  Deps.autorun ->
    if not Meteor.user()
      $('#signup').modal('show')
    else
      $('#signup').modal('hide')
      $('.modal-backdrop').remove() #buggy bootstrap :(




# Searching
###########



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

  if not results?
    return


  # Hide your own vetoes
  my_vetos = (vote.venue for vote in votes when vote.type == 'veto' and vote.user == Meteor.userId())
  results = _.reject results, (result) -> _.contains my_vetos, result.venue.id

  # Annotate
  results = for result in results
    vetos = Votes.find
      venue: result.venue.id
      type: 'veto'
    .fetch()
    result.vetoers = (Meteor.users.findOne(veto.user)?.profile.name for veto in vetos)

    upvotes = Votes.find
      venue: result.venue.id
      type: 'upvote'
    .fetch()
    result.upvoters = (Meteor.users.findOne(upvote.user)?.profile.name for upvote in upvotes)

    result

  Session.set 'loading', false
  return _.first _.sortBy(results, (r) -> r.vetoers.length - r.upvoters.length), 5



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