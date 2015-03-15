define ["js/app", "js/apps/map_app/show/show_view"], (App, View) ->
	App.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->
		Show.Controller =
			showLocation: ->
				if @showView is undefined
					@showView = new View.ShowView()
				App.mainRegion.show(@showView)

	App.MapApp.Show.Controller

