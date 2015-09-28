define ["js/app", "js/apps/nav_app/show/show_view"], (App, View) ->
	App.Entity.Navigation = Backbone.Model.extend()
	App.module "NavApp.Show", (Show, App, Backbone, Marionette, $, _) ->
		Show.Controller =
			showNavigation: () ->
				navigation = new App.Entity.Navigation 
					statelist: "All artists"
					statelocation: "All locations"
					statebio: ""
				console.log "navigation", navigation
				@showView = new View.ShowView(model: navigation)
				# console.log "@showView",@showView
				App.navRegion.show @showView
	App.NavApp.Show.Controller

