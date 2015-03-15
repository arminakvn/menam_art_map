define ["js/app", "js/apps/person_app/show/show_view"], (App, View) ->
	App.module "PersonApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	    Show.Controller =
	    	showPerson: ->
	    		if @showView is undefined
	    			@showView = new View.ShowView()
	    		App.mainRegion.show(@showView)
	App.PersonApp.Show.Controller

