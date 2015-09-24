define ["js/app", "js/apps/map_app/show/show_view", "tpl!js/apps/map_app/show/templates/bio_view.tpl", "tpl!js/apps/map_app/show/templates/bios_view.tpl"], (App, View, BioViewTpl,BiosViewTpl) ->
	App.Entity.BioElement = Backbone.Model.extend()
	App.Entities.BioElementTextCollection = Backbone.Collection.extend(
	    model: App.Entity.BioElement
	    initialize:->	
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
	    	url = App.MapApp.Show.Controller.showView.url
	    	url
	    parse: (response) ->
	      splirR = response[0].__text.split(' ')
	      # splitResponse = response.split(' ')
	      # console.log "splite", splitResponse
	      data = _.map splirR, (key, value) =>
	        # _.map key, (key, value) =>
	          # key
	        # "name": key.__text.split(' ')
	        'name': key
	      console.log "App.MapApp.Show.Controller.showView.list", App.MapApp.Show.Controller.showView.list
	      data
	      # for each in data.name
	      # 	console.log each
	      # # for name in data_names
	      # 	if each in App.MapApp.Show.Controller.showView.list
	      # 		console.log "name", each
	      # 	data


	      # response.data

	  )
	App.Entity.LocationNode = Backbone.Model.extend()
	App.Entity.LocationState = Backbone.Model.extend()
	App.Entities.LocationNodeCollection = Backbone.Collection.extend(
		model: App.Entity.LocationNode
		initialize:  ->
			@on 'request', ->
				console.log "loading"
				return
			@on 'sync', ->
				console.log "loaded"
				return
			return
		url:-> 
			# if @showView != undefined
			# 	new_url = 'artistsbysource/' + @showView.names
			# 	full_url = new_url
			# 	full_url
			# else
			# 	full_url = '/artistsbygroup/1'
			# 	full_url
			'/artistsbygroup/1'
		parse: (response) ->
			console.log "response", response
			data = _.map response, (key, value) =>
				'name' :key.source
				'group': key.group
				'id':key._id
				'lat': key.lat
				'long': key.long
				'source': key.source
				'target': key.target
			data
	)
	App.Entities.LocationNodeSelectedCollection = Backbone.Collection.extend()


	App.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->
		Show.Controller =
			showLocation: ->
				locationNodes = new App.Entities.LocationNodeCollection
				locationNavigator = new App.Entity.LocationState({'state': 'World'})
				console.log "locationNavigator", locationNavigator
				locationNodes.fetch 'success': (response) =>
					@showView = new View.ShowView(collection:locationNodes, model: locationNavigator)
					App.mainRegion.show(@showView)
			resetMapHighlights: () =>
				@Controller.showView.nodeGroup.eachLayer (layer) =>
					layer.setStyle
						opacity: 0.1
						fillOpacity: 0.1
						clickable: false
					@Controller.showView._m.setView([
						42.34
						0.12
					], 3)
					return
			showLocationByGroup: (locationGroup) =>
				# console.log "locationGroup",locationGroup
				# filteredModel = $.ajax "/sourceByTarget/#{locationGroup}",
		  #   			type: 'GET'
		  #   			dataType: 'json'
		  #   			error: (jqXHR, textStatus, errorThrown) ->
		  #   			success: (data, textStatus, jqXHR) =>
		  #   				console.log "showLocationByGroup", data
		  #   				return data
				# filteredModel = App.request "update:artistsource", "/artstsby/#{locationGroup}"
				# console.log "App.request updateartistsource", App.request "update:artistsource", "/artstsby/#{locationGroup}"
				# $.when(filteredModel).done (Model) =>
					# console.log "filtered model?", Model
				# $.when(filteredModel).done (locationGroup) =>
				App.MainApp.Show.Controller.updateView(locationGroup)

				# filteredModel = App.request "artistsourceCollectionBy", locationGroup
				# $.when(filteredModel).done (Model) =>
				# 	console.log "filtered model?", Model
				# 	App.MainApp.Show.Controller.showView.model = App.request "artistsource", Model

			hideBio: () =>
				@Controller.showView.fx.run(L.DomUtil.get(@Controller.showView._bios_domEl), L.point(-$(@Controller.showView._m.getContainer())[0].clientWidth/1.2, 0), 0.5)

			showBio: (d) =>
		    	L.DomUtil.setOpacity(L.DomUtil.get(@Controller.showView._bios_domEl), 0.75)
		    	@d = d
		    	@Controller.showView.url = "/biosby/#{d}"
		    	bioCollection = new App.Entities.BioElementTextCollection
		    	bioCollection.fetch 'success': (response) =>
		    		console.log "bios response", response
		    	@Controller.showView.fx.run(L.DomUtil.get(@Controller.showView._bios_domEl), L.point(-$(@Controller.showView._m.getContainer())[0].clientWidth/3, 40), 0.5)
		    	L.DomUtil.get(@Controller.showView._bios_domEl).innerHTML = "" 
		    	bioView = Marionette.ItemView.extend(
		    		template: BioViewTpl
		    	)
		    	bioView
		    	biosView = Marionette.CompositeView.extend(
		    		itemView: bioView
		    		# itemViewContainer: 'div'
		    		template: BiosViewTpl
		    		id:"bioview"
		    		onShow: ->
		    			console.log "bioView"
		    	)
		    	biosView
		    	if @biosFetched is undefined
		    		$.ajax "/biosby/#{d}",
		    			type: 'GET'
		    			dataType: 'json'
		    			error: (jqXHR, textStatus, errorThrown) ->
		    			success: (data, textStatus, jqXHR) =>
		    				$el = $('#bios')
		    				@biosTextResults = data
		    				console.log "data", data, "@biosTextResults", @biosTextResults
		    				L.DomUtil.get(@Controller.showView._bios_domEl).innerHTML = "" 
		    				aBioView = new biosView(collection: bioCollection)
		    				aBioView.render()
		    				# L.DomUtil.get(@Controller.showView._bios_domEl).innerHTML += "#{@biosTextResults[0].__text}"
		    				console.log "aBioView", aBioView
		    				L.DomUtil.get(@Controller.showView._bios_domEl).innerHTML = aBioView.el.innerHTML
		    	else
		    		console.log "else notheing"
		    	return

			highlightNodesBy: (sourceNode) =>
				# console.log "@ inside highlightNodesBy", @
				# @Controller.showBio(sourceNode)
				updateCollection = $.ajax '/artistsbysource/'+sourceNode,
		              type: 'GET'
		              dataType: 'json'
		              error: (jqXHR, textStatus, errorThrown) ->
		                # $('body').append "AJAX Error: #{textStatus}"
		              success: (data, textStatus, jqXHR) =>
		              	console.log "ret data", data
		              	ret = _.map data, (key, value) =>
		              		"target": key.target
		        $.when(updateCollection).done (respnd) =>
		          output = []
		          console.log "App.MapApp.Show.Controller.showView.model", App.MapApp.Show.Controller.showView
		          App.MapApp.Show.Controller.showView.model.destroy()
		          App.MapApp.Show.Controller.showView.model = new App.Entity.ArtistListState({'state': 'World > ' + sourceNode})
		          App.MapApp.Show.Controller.showView.render()
		          App.MapApp.Show.Controller.showView.collection.each (initmodels) =>
		              output.push initmodels.get('target')
		              # console.log "this is the out put which is a list of the list in the left", output
		          # console.log "respnd when done", respnd
		          # console.log "updateCollection when done", updateCollection
		              
		          App.MapApp.Show.Controller.showView.children.each (childView) =>
		            # console.log "childModel.get('target')", childModel.get('target')
		            childModel = childView.model
		            if childModel.get('target') not in respnd
		              # thrn = childModel.get('name')
		              # App.MainApp.Show.Controller.showView.filter(App.MainApp.Show.Controller.showView.collection.get(childModel), App.MainApp.Show.Controller.showView.collection)
		              # @showView.children.remove(App.MainApp.Show.Controller.showView.children.findByModel(App.MainApp.Show.Controller.showView.collection.get(childModel)))
		              # model_rem = App.MainApp.Show.Controller.showView.collection.get(childModel)
		              App.MainApp.Show.Controller.showView.collection.remove(App.MapApp.Show.Controller.showView.collection.get(childModel))
		          respnd.forEach (name_res) =>
		            if sourceNode not in output
		              App.MapApp.Show.Controller.showView.collection.add(new App.Entity.LocationNode({'target': key.target}))


				@_sourceNode = sourceNode
				@Controller.showView.nodeGroup.eachLayer (layer) =>
					@Controller.showView.popupGroup.clearLayers()
					layer.setStyle
						opacity: 0.0
						fillOpacity: 0.0
						weight: 2
						clickable: false
					timeout = 0
				$.ajax "/artistsbysource/#{sourceNode}",
					type: 'GET'
					dataType: 'json'
					error: (jqXHR, textStatus, errorThrown) ->
					# $('body').append "AJAX Error: #{textStatus}"
					success: (data, textStatus, jqXHR) =>
						@Controller.showView.list = _.pluck data, 'target'
						@Controller.showView.nodeGroup.eachLayer (layer) =>
							if layer.options.id in @Controller.showView.list
								$(L.DomUtil.get(layer._container)).addClass('highlighted')
								# console.log "$(L.DomUtil.get(layer._path))[0]",layer._path
								# console.log "layer", layer
								# console.log "layer._leaflet_id", layer._leaflet_id
								# console.log "layer.$(layer)", $(layer)
								
								# popup = new L.Popup()
								# ltlng = new L.LatLng(layer._latlng.lat, layer._latlng.lng)
								# popup.setLatLng(ltlng)
								# popup.setContent("")
								# popup.setContent(layer.options.id)
								# console.log "@Controller.showView._m._layers", @Controller.showView._m._layers[layer._leaflet_id]
								# @Controller.showView.popupGroup.addLayer(popup)
								layer.bringToFront()
								# nodes = @Controller.showView._m._layers
								# for node in nodes
								# 	console.log "node.iid", node._leaflet_id
								# 	console.log "node", node
								# 	node.options.className = 'locations-nodes highlighted'
								# 	return
								# $(L.DomUtil.get(layer._path)).addClass('artistshighleted')
								# maplayers = @Controller.showView._m.getLayers()
								# console.log "maplayers", maplayers
								$(@Controller.showView._m._layers[layer._leaflet_id]._container.lastChild).addClass('highlighted')
								# console.log "@Controller.showView._m._layers 2", @Controller.showView._m._layers[layer._leaflet_id]
								timeout = 0
								setTimeout (->
									$(L.DomUtil.get(layer._container)).animate
										fillOpacity: 0.8
										opacity: 0.9
									, 1, ->
										layer.setStyle
											# className: 'locations-nodes highlighted'
											fillOpacity: 0.8
											weight: 2
											opacity: 1
											clickable: true
								)
				return 
	App.MapApp.Show.Controller

