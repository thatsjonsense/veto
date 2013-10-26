@templateHelpers =
  commas: (list) ->
    if list.length > 1
      _.initial(list).join(', ') + ' and ' + _.last(list)
    else
      list[0]


for name, helper of templateHelpers
  Handlebars.registerHelper(name,helper)