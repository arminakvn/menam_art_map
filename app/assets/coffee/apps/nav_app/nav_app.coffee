define ["js/app"], (App) ->
  App.module "NavApp", (NavApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = true
    App.Router = Marionette.AppRouter.extend(
      appRoutes:
        navigation:"showNavigation"
    )
    API =
      showNavigation: ()->
        require ["js/apps/nav_app/show/show_controller"], ->
          App.NavApp.Show.Controller.showNavigation()
      showModal: ()->
        require ["js/apps/nav_app/show/show_controller"], ->
          App.NavApp.Show.Controller.showModal()
    App.addInitializer ->
      new App.Router(controller: API)
      API.showNavigation()
  App.NavApp
