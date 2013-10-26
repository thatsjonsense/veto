
Template.search.query = ->
  Session.get 'query'

Template.search.loading_results = ->
  Session.get 'loading_results'

Template.search.rendered = ->
  $('.card').draggable
    axis: 'x'
    revert: true
    drag: onCardDrag
    stop: onCardDragStop

Template.search.results = ->
 results = Session.get 'results'
 results?[...3]

Template.search.events =
  'keyup .searchBox': (evt, template) ->
    Session.set 'query', $('.searchBox').val()




# Search
#########

updateResults = (query, votes) ->
  vetos = _.where votes, {type: 'veto'}
  vetoed_venues = _.pluck vetos, 'venue'

  Meteor.call 'get_venues', query, 'Seattle', (err, results) ->
    
    venues = _.reject results, (result) -> _.contains vetoed_venues, result.venue.id 

    Session.set 'results', venues
    Session.set 'loading_results', false

updateResultsThrottled = _.debounce(updateResults, 300)

Deps.autorun ->
  query = Session.get 'query'
  votes = Votes.find().fetch()

  Session.set 'loading_results', true
  updateResults query, votes


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