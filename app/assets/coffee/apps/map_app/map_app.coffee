define ["js/app"], (App) ->
  App.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = true
    App.commands.setHandler 'showLocation', (sourceNode) ->
      API.showLocation(sourceNode)
      return
    App.commands.setHandler 'highlightNode', (sourceNode) ->
      API.highlightNode(sourceNode)
      return
    App.commands.setHandler 'showBio', (sourceNode) ->
      API.showBio(sourceNode)
      return
    App.commands.setHandler 'hideBio', () ->
      API.hideBio()
      return
    App.commands.setHandler 'showLocationGroup', (locationGroup) ->
      API.showLocationByGroup(locationGroup)
      return
    App.Router = Marionette.AppRouter.extend(
      appRoutes:
        "location/":"showLocation"
        "location/:locationGroup":"showLocationByGroup"
    )
    # App.vent.on 'show:LocationByGroup', (q) ->
    #   Backbone.history.navigate "location/#{q}", { trigger: true }
    API =
      showLocation: ->
        require ["js/apps/map_app/show/show_controller"], ->
          App.MapApp.Show.Controller.showLocation()
          console.log "inside API"

      highlightNode: (sourceNode)->
        require ["js/apps/map_app/show/show_controller"], ->
          App.MapApp.Show.Controller.highlightNodesBy(sourceNode)

      showBio: (sourceNode)->
        require ["js/apps/map_app/show/show_controller"], ->
          App.MapApp.Show.Controller.showBio(sourceNode)

      hideBio: ()->
        require ["js/apps/map_app/show/show_controller"], ->
          App.MapApp.Show.Controller.hideBio()

      showLocationByGroup: (locationGroup) ->
        require ["js/apps/map_app/show/show_controller"], ->
          App.MapApp.Show.Controller.showLocationByGroup(locationGroup)
    
    App.addInitializer ->
      new App.Router
        controller: API
  App.MapApp