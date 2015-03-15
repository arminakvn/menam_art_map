define ["js/app"], (App) ->
  App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
    Entities.PersonLinkCollection = Backbone.Collection.extend(
    )
    Entities.PersonLink = Backbone.Model.extend(
    )
    initializePersonLink = new Entities.PersonLink(
    )

    API =
      getPersonLinkEntity: ->
        defer = $.Deferred()
        defer.resolve initializePersonLink
        defer.promise()

      setPersonLink: (personLinks) ->
        App.PersonLinkCollection = new Entities.PersonLinkCollection personLinks


    App.reqres.setHandler "personLink", ->
      API.getPersonLinkEntity()

    App.reqres.setHandler "set:personLink", (personLinks) ->
      API.setPersonLink personLinks

  return