define ["js/app"], (App) ->
  App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
    Entities.Header = Backbone.Model.extend(
      defaults:
        title: "Hello App"
    )
    initializeHeader = new Entities.Header(
      title: "Hello artistsnetwork "
      message: "Everything is working, ...purrfectly"
    )

    API =
      # get feed model by Id
      getHeaderEntity: ->
        defer = $.Deferred()
        defer.resolve initializeHeader
        defer.promise()

    App.reqres.setHandler "header", ->
      API.getHeaderEntity()

  return