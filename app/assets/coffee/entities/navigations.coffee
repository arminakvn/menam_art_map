define ["js/app"], (App) ->
  App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
    Entity.Navigation = Backbone.Model.extend(
      defaults:
        state_list: "All"
        state_location: "All"
        state_bio: "organization"
    )
    Entities.NavigationCollection = Backbone.Collection.extend(
      model: Entity.Navigation
    )
    initializeNavigation = new Entity.Navigation(
      state_list: "All"
      state_location: "All"
      state_bio: "organization"
    )
    API =
      getNavigationEntity: ->
        defer = $.Deferred()
        defer.resolve initializeNavigation
        defer.promise()
      
      getNavigation: ->
        new Entities.NavigationCollection [
          { state_list: "All"}
          { state_location: "All"}
          { state_bio: "organization"}
          # { name: "biotrajectories"}
        ]
    App.reqres.setHandler "navigation", ->
      console.log "inside navigation"
      API.getNavigationEntity()
  
    App.reqres.setHandler "navigation:entities", ->
      API.getNavigation()

  return