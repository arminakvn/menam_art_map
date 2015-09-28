define ["js/app"], (App) ->
  App.module "MainApp", (MainApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = false
    App.Router = Marionette.AppRouter.extend(
      appRoutes:
        "/":"showView"

    )
    API =
      showView: ->
        require ["js/apps/main_app/show/show_controller"], ->
          App.MainApp.Show.Controller.showView()
      

    App.addInitializer ->
      new App.Router(controller: API)
      API.showView()

    this == MainApp
    myData = 'this is private data'
    DistinctLocationsList = ''
    ifControl = false
    # noFollowLinks = true
    inWidth = 60

  App.MainApp