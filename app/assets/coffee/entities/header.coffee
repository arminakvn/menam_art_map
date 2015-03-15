define ["js/app"], (App) ->
  App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
    Entities.Header = Backbone.Model.extend(
      defaults:
        title: ""
    )
    Entities.HeaderCollection = Backbone.Collection.extend(
      model: Entities.Header
    )
    initializeHeader = new Entities.Header(
      title: ""
    )
    API =
      getHeaderEntity: ->
        defer = $.Deferred()
        defer.resolve initializeHeader
        defer.promise()
      
      getHeaders: ->
        new Entities.HeaderCollection [
          { name: "location"}
          { name: "person"}
          { name: "organization"}
          # { name: "biotrajectories"}
        ]
    App.reqres.setHandler "header", ->
      API.getHeaderEntity()
  
    App.reqres.setHandler "header:entities", ->
      API.getHeaders()

  return