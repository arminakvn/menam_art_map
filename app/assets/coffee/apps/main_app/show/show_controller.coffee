define ["js/app", "js/apps/main_app/show/show_view"], (App, View) ->
  App.module "MainApp.Show", (Show, App, Backbone, Marionette, $, _) ->
    Show.Controller =
      ShowModel =
      showView: ->
      	require ["js/entities/artist_source"], =>
      		getCollection = App.request "set:collection", 'artistssource'
      		$.when(getCollection).done (artists) ->
	      		showView = new View.ShowView()
	      		App.mainRegion.show showView

  App.MainApp.Show.Controller

