define ["js/app"], (App) ->
  App.module "HeaderApp", (HeaderApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = true
    App.Router = Marionette.AppRouter.extend(
      appRoutes:
        header:"showHeader"
    )
    API =
      showHeader: ->
        require ["js/apps/header_app/show/show_controller"], ->
          App.HeaderApp.Show.Controller.showHeader()

    # App.on "header:show", ->

      # console.log("API.showHeader()")
      

    App.addInitializer ->
      new App.Router(controller: API)
      API.showHeader()
  App.HeaderApp
