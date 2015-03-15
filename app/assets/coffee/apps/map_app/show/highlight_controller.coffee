define ["js/app", "js/apps/map_app/show/show_view"], (App, View) ->
	App.module "MapApp.Highlight", (Highlight, App, Backbone, Marionette, $, _) ->
	    Highlight.Controller =
	    	highlightNodesBy: (sourceNode) =>
	    		Highlight._sourceNode = sourceNode
	    		View.nodeGroup.eachLayer (layer) =>
	          		View.popupGroup.clearLayers()
	          		layer.setStyle
		          		opacity: 0.4
		          		fillOpacity: 0.4
		          		weight: 2
		          		clickable: false
					timeout = 0
					# View.markers.eachLayer (layer) =>
			  #         	layer.setStyle
			  #           	opacity: 0.1
			  #           	fillOpacity: 0.1
			  #           	clickable: false
				 #        setTimeout (=>
				 #        	console.log "App", App
				 #        	# $(L.DomUtil.get(layer._container)).animate
				 #            	# fillOpacity: 0.3
				 #            	# opacity: 0.3
				 #          	, 10, ->
				 #        )
				@_links.forEach (link) -> 
					if link.source.name == Highlight._sourceNode
		            	View.markers.eachLayer (layer) =>
		              		layer.setStyle
		                		opacity: 0.6
		                		clickable: true
		            	View.nodeGroup.eachLayer (layer) =>
		            		if layer.options.className == "#{link.target.index}"
		                		popup = new L.Popup()
		                		ltlng = new L.LatLng(layer._latlng.lat, layer._latlng.lng)
		                		popup.setLatLng(ltlng)
		                		popup.setContent("")
		                		popup.setContent(layer.options.id)
		                		View.popupGroup.addLayer(popup)
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
	App.MapApp.Highlight.Controller
