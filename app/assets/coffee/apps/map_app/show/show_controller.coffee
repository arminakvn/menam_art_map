define ["js/app", "js/apps/map_app/show/show_view"], (App, View) ->
	App.module "MapApp.Show", (Show, App, Backbone, Marionette, $, _) ->
		Show.Controller =
			showLocation: ->
				if @showView is undefined
					@showView = new View.ShowView()
				App.mainRegion.show(@showView)

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
				$.ajax "/artistsbysource/#{sourceNode[0]}",
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

	App.MapApp.Show.Controller

