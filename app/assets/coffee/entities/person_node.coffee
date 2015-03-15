define ["js/app"], (App) ->
  App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
    Entities.PersonNodeCollection = Backbone.Collection.extend(
    )
    Entities.PersonNode = Backbone.Model.extend(
    )
    initializePersonNode = new Entities.PersonNode(
    )

    API =
      getPersonNodeEntity: ->
        defer = $.Deferred()
        defer.resolve initializePersonNode
        defer.promise()

      setPersonNode: (personNodes) ->
        App.PersonNodeCollection = new Entities.PersonNodeCollection personNodes


    App.reqres.setHandler "personNode", ->
      API.getPersonNodeEntity()

    App.reqres.setHandler "set:personNode", (personNodes) ->
      API.setPersonNode personNodes

  return