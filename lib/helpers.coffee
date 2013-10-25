@log = (args...) ->
  console.log args...

@prettify = (obj) ->
  JSON.stringify(obj, null, 2)