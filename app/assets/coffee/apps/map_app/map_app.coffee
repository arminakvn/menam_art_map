define ["js/app"], (App) ->
  App.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = true
    App.commands.setHandler 'showLocation', () ->
      API.showLocation()
      return
    App.commands.setHandler 'highlightNode', (sourceNode) ->
      API.highlightNode(sourceNode)
      return
    
    App.commands.setHandler 'showLocationByName', (name) ->
      API.showLocationByExistingCollection()
      App.MapApp.Show.Controller.showView.collection.on "sync", ->
        API.highlightNode(name)
      return

    App.commands.setHandler 'showLocationGroup', (locationGroup) ->
      API.showLocation()
      return
    App.Router = Marionette.AppRouter.extend(
      appRoutes:
        "location/":"showLocation"
        "location/:locationGroup":"showLocation"
    )
    # App.vent.on 'show:LocationByGroup', (q) ->
    #   Backbone.history.navigate "location/#{q}", { trigger: true }
    API =
      showLocation: (sourceNode)->
        require ["js/apps/map_app/show/show_controller"], ->
          App.MapApp.Show.Controller.showLocation()
          console.log "inside API"

      highlightNode: (sourceNode)->
        require ["js/apps/map_app/show/show_controller"], ->
          App.MapApp.Show.Controller.highlightNodesBy(sourceNode)



      showLocationByExistingCollection: () ->
        require ["js/apps/map_app/show/show_controller"], ->
          App.MapApp.Show.Controller.showLocationByExistingCollection() 
      showLocationByGroup: (locationGroup) ->
        require ["js/apps/map_app/show/show_controller"], ->
          App.MapApp.Show.Controller.showLocationByGroup(locationGroup)
    
    App.addInitializer ->
      new App.Router
        controller: API
  App.MapApp