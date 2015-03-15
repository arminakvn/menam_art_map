define ["js/app"], (App) ->
  App.module "PersonApp", (PersonApp, App, Backbone, Marionette, $, _) ->
    @startWithParent = true
    console.log App
    App.Router = Marionette.AppRouter.extend(
      appRoutes:
        "person/":"showPerson"
    )
    API =
      showPerson: ->
        require ["js/apps/person_app/show/show_controller"], ->
          App.PersonApp.Show.Controller.showPerson()
    App.addInitializer ->
      new App.Router
          controller: API
  App.PersonApp
