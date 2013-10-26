@log = (args...) ->
  console.log args...

@prettify = (obj) ->
  JSON.stringify(obj, null, 2)

_.extend Meteor.Collection.prototype,
  findOrInsert: (obj) -> @findOne(obj) ? @findOne(@insert(obj))