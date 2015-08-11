define ["js/app", "js/apps/map_app/show/show_view"], (App, View) ->
	App.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->
		Show.Controller =
			showLocation: ->
				if @showView is undefined
					@showView = new View.ShowView()
				App.mainRegion.show(@showView)
			showLocationByGroup: (locationGroup) =>
				filteredModel = App.request "update:artistsource", "/artstsby/#{locationGroup}"
				# console.log "App.request updateartistsource", App.request "update:artistsource", "/artstsby/#{locationGroup}"
				$.when(filteredModel).done (Model) =>
					console.log "filtered model?", Model

				# filteredModel = App.request "artistsourceCollectionBy", locationGroup
				# filteredModel = $.ajax "/artstsby/#{locationGroup}",
		  #   			type: 'GET'
		  #   			dataType: 'json'
		  #   			error: (jqXHR, textStatus, errorThrown) ->
		  #   			success: (data, textStatus, jqXHR) =>
		  #   				return data
				# $.when(filteredModel).done (Model) =>
				# 	console.log "filtered model?", Model
				# 	App.MainApp.Show.Controller.showView.model = App.request "artistsource", Model

			showBio: (d) =>
		    	L.DomUtil.setOpacity(L.DomUtil.get(@Controller.showView._bios_domEl), 0.75)
		    	@Controller.showView.fx.run(L.DomUtil.get(@Controller.showView._bios_domEl), L.point(-$(@Controller.showView._m.getContainer())[0].clientWidth/3, 40), 0.5)
		    	L.DomUtil.get(@Controller.showView._bios_domEl).innerHTML = "" 
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
		    				L.DomUtil.get(@Controller.showView._bios_domEl).innerHTML += "#{@biosTextResults[0].__text}"
		    	else
		    		console.log "else notheing"
		    	return

			highlightNodesBy: (sourceNode) =>
				@_sourceNode = sourceNode
				@Controller.showView.nodeGroup.eachLayer (layer) =>
					@Controller.showView.popupGroup.clearLayers()
					layer.setStyle
						opacity: 0.0
						fillOpacity: 0.0
						weight: 2
						clickable: false
					timeout = 0
					@Controller.showView.markers.eachLayer (layer) =>
						layer.setStyle
							opacity: 0.1
							fillOpacity: 0.1
							clickable: false
						# setTimeout (=>
						# 	, 10, ->
						# )
				$.ajax "/artistsbysource/#{sourceNode}",
					type: 'GET'
					dataType: 'json'
					error: (jqXHR, textStatus, errorThrown) ->
					# $('body').append "AJAX Error: #{textStatus}"
					success: (data, textStatus, jqXHR) =>
						list = _.pluck data, 'target'
						@Controller.showView.nodeGroup.eachLayer (layer) =>
							if layer.options.id in list
		                		popup = new L.Popup()
		                		ltlng = new L.LatLng(layer._latlng.lat, layer._latlng.lng)
		                		popup.setLatLng(ltlng)
		                		popup.setContent("")
		                		popup.setContent(layer.options.id)
		                		@Controller.showView.popupGroup.addLayer(popup)
		                		layer.bringToFront()
		                		timeout = 0
		                		setTimeout (->
		                  			$(L.DomUtil.get(layer._container)).animate
		                    			fillOpacity: 0.8
		                    			opacity: 0.9
		                  			, 1, ->
		                    			layer.setStyle
		                        			fillOpacity: 0.8
		                        			weight: 2
		                        			clickable: true
		                		)
		        return 
	App.MapApp.Show.Controller

