define ["js/app", "js/apps/person_app/show/show_view"], (App, View) ->
	App.Entities.PersonNode = Backbone.Model.extend()
	App.Entities.PersonNodeCollection = Backbone.Collection.extend(
      initialize:  ->
        @on 'request', ->
          # MfiaClient.app.trigger 'loading'
          console.log "loading"
          return
        @on 'sync', ->
          # MfiaClient.app.trigger 'loaded'
          console.log "loaded"
          return
        return
      url:-> 
        return "/nodes"
      
      parse: (response) ->
        # console.log "response", response
        data = _.map response, (key, value) =>
          # _.map key, (key, value) =>
            # key
          "name": key
        data

    )
	App.module "PersonApp.Show", (Show, App, Backbone, Marionette, $, _) ->
	    Show.Controller =
	    	showPerson: ->
	    		artistNodes = new App.Entities.PersonNodeCollection
	    		artistNodes.fetch 'success': (response) =>
		            console.log 'artistNodes response', response		            
		    		if @showView is undefined
		    			@showView = new View.ShowView(collection: artistNodes)
		    		App.mainRegion.show(@showView)
	App.PersonApp.Show.Controller

