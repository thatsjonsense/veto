
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




# Dragon drop

THRESHOLD = 250

color = d3.scale.linear()
    .domain([-THRESHOLD,0,THRESHOLD])
    .range(['red','white','green'])
    .clamp(true)

opacity = d3.scale.linear()
  .domain([-THRESHOLD,0,THRESHOLD])
  .range([0.1,1.0,1.0])
  .clamp(true)


YES_GIFS =
  tracy: 'http://media1.giphy.com/media/vqETCS0NfdCJq/200.gif'
  liz: 'http://media2.giphy.com/media/LPoK5VOu3qJDW/200.gif'

NO_GIFS =
  liz: 'http://media3.giphy.com/media/QrvRiHPzlVY6Q/200.gif'
  octopus: 'http://media3.giphy.com/media/yMaLDA976YtUs/200.gif'


Template.search.rendered = ->
  $('.card').draggable
    axis: 'x'
    revert: true
    drag: (event, ui) ->
      offset = ui.position.left
      rail = ui.helper.closest('.rail')
      card = ui.helper

      #if offset < -100
      #  ui.helper.css('background-color','red')
      
      if false
        if offset < 0
          rail.css('background-image',"url('#{NO_GIFS['liz']}')") 
          rail.css('background-position','right')

        if offset > 0
          rail.css('background-image',"url('#{YES_GIFS['liz']}')") 
          rail.css('background-position','left')


      #rail.css('background-color',color offset)
      card.css('opacity',opacity offset)
      #log offset, opacity offset

    stop: (event, ui) ->
      offset = ui.position.left
      rail = ui.helper.closest('.rail')
      card = ui.helper

      card.css('opacity',1)
      


      if offset <  -THRESHOLD
        log 'vetoed'

        #rail.fadeOut()

      else if offset > THRESHOLD
        log 'voted'


      else
        # revert



updateResults = (query) ->
  Meteor.call 'get_venues', query, 'Seattle', (err, result) ->
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