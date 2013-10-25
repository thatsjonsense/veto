
###
Template.search.events =
  'click #search': (event, template) ->
    log 'searching...'
    log template.find('#query').value
###

Template.search.query = ->
  Session.get 'query'

Template.search.loading_results = ->
  Session.get 'loading_results'


Template.search.rendered = ->
  $('li').draggable
    axis: 'x'
    revert: true


updateResults = (query) ->
  Meteor.call 'get_venues', query, 'Bellevue, WA', (err, result) ->
    Session.set 'results', result
    Session.set 'loading_results', false

updateResultsThrottled = _.debounce(updateResults, 300)

Deps.autorun ->
  query = Session.get 'query'
  Session.set 'loading_results', true
  updateResultsThrottled query
  



Template.search.results = ->
 results = Session.get 'results'
 results?[...3]

Template.search.events =
  'keyup .searchBox': (evt, template) ->
    Session.set 'query', $('.searchBox').val()