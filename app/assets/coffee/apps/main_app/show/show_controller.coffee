define ["js/app", "js/apps/main_app/show/show_view"], (App, View) ->
  App.module "MainApp.Show", (Show, App, Backbone, Marionette, $, _) ->
    Show.Controller =
      ShowModel =
      showView: ->
       	showView = new View.ShowView()
       	App.mainRegion.show showView

  App.MainApp.Show.Controller

