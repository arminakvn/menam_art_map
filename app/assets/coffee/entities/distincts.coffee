define ["js/app"], (App) ->
  App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
    Entities.DistinctsCollection = Backbone.Collection.extend(
    )
    Entities.DistinctLink = Backbone.Model.extend(
    )
    initializeDistinctLink = new Entities.DistinctLink(
    )

    API =
      getDistinctLinkEntity: ->
        defer = $.Deferred()
        defer.resolve initializeDistinctLink
        defer.promise()

      setDistinctLink: (distinctLinks) ->
        App.DistinctLinkCollection = new Entities.DistinctsCollection distinctLinks


    App.reqres.setHandler "distinctLink", ->
      API.getDistinctLinkEntity()

    App.reqres.setHandler "set:distinctLink", (distinctLink) ->
      API.setDistinctLink distinctLink

  return