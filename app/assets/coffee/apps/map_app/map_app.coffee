define ["js/app"], (App) ->
  App.module "MapApp", (MapApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = true
    App.commands.setHandler 'highlightNode', (sourceNode) ->
      API.highlightNode(sourceNode)
      return
    App.Router = Marionette.AppRouter.extend(
      appRoutes:
        "location/":"showLocation"
    )
    API =
      showLocation: ->
        require ["js/apps/map_app/show/show_controller"], ->
          App.MapApp.Show.Controller.showLocation()
          console.log "inside API"

      highlightNode: (sourceNode)->
        require ["js/apps/map_app/show/highlight_controller"], ->
          App.MapApp.Highlight.Controller.highlightNodesBy(sourceNode)

      # resetHighlightNode: ()->
      #   App.MapApp.Highlight.Controller.resetHighlightNodesBy()

    App.addInitializer ->
      new App.Router
          controller: API
      # API.showView()

  App.MapApp