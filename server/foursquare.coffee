

CLIENT_ID = 'DLLGBS4KTGCNAG1AV1QDQHVBXJLN5JTBY3JGQP2SK45DUADI'
CLIENT_SECRET = 'RS3OVZA0XUQ4C5ET1CAA04YB0GPLFPOGDWAVIKX0NHNCF5FX'

BASE_URL = "https://api.foursquare.com/v2/venues/explore?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}&v=20131024"


getFoursquareResponse = (query, near) ->
  url = BASE_URL + "&query=#{query}"

  params =
    'query': query
    'near': near
    'venuePhotos': 1

  console.log params
  result = HTTP.get url, {params: params}

  return result.data.response.groups[0].items


Meteor.methods

  'get_venues': getFoursquareResponse




Meteor.Router.add '/test/foursquare/:query', (query) ->
    prettify getFoursquareResponse(query,'Seattle')
