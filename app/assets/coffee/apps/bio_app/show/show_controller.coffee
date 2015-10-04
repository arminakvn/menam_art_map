define ["js/app", "js/apps/bio_app/show/show_view", "tpl!js/apps/bio_app/show/templates/bio_view.tpl", "tpl!js/apps/bio_app/show/templates/bios_view.tpl"], (App, View, BioViewTpl,BiosViewTpl) ->
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
	    	url = "/biosby/#{App.BioApp.Show.Controller.url}" 
	    	# console.log "url", url
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
	      data
	      # for each in data.name
	      # 	console.log each
	      # # for name in data_names
	      # 	if each in App.MapApp.Show.Controller.showView.list
	      # 		console.log "name", each
	      # 	data


	      # response.data

	  )
	
	App.module "BioApp.Show", (Show, App, Backbone, Marionette, $, _) ->
		Show.Controller =

			listLevelOne: (sourceNode) ->
				# console.log "sourceNode", '/distLocbysourceartist/'+sourceNode.replace /^\s+|\s+$/g, ""
				updateCollection = $.ajax '/distLocbysourceartist/'+sourceNode.replace /^\s+|\s+$/g, "",
		              type: 'GET'
		              dataType: 'json'
		              error: (jqXHR, textStatus, errorThrown) ->
		                # $('body').append "AJAX Error: #{textStatus}"
		              success: (data, textStatus, jqXHR) =>
		              	ret = _.map data, (key, value) =>
		              		"target": key.target
		        $.when(updateCollection).done (respnd) =>
		          respnd
		        updateCollection

			hideBio: () =>
				# @Controller.showView.fx.run(L.DomUtil.get(@Controller.showView._bios_domEl), L.point(-$(@Controller.showView._m.getContainer())[0].clientWidth/1.2, 0), 0.5)

			showBio: (artist) =>
		    	# L.DomUtil.setOpacity(L.DomUtil.get(@Controller.showView._bios_domEl), 0.75)
		    	@artist = artist
		    	App.NavApp.Show.Controller.showView.model.attributes.statebio = "#{artist}"
		    	# console.log "App.NavApp.Show.Controller.showView.model.attributes.statebio", App.NavApp.Show.Controller.showView.model.attributes.statebio
		    	App.BioApp.Show.Controller.url = artist
		    	bioCollection = new App.Entities.BioElementTextCollection
		    	bioCollection.fetch 'success': (response) =>
		    		@showView = new View.ShowViews(collection: response)
		    		App.bioRegion.show(@showView)
		    	# @Controller.showView.fx.run(L.DomUtil.get(@Controller.showView._bios_domEl), L.point(-$(@Controller.showView._m.getContainer())[0].clientWidth/2.6, 0.5), 0.5)
		    	# L.DomUtil.get(@Controller.showView._bios_domEl).innerHTML = "" 
		    	# bioView = Marionette.ItemView.extend(
		    	# 	template: BioViewTpl
		    	# 	className: ->
		    	# 		# if @mode.attribute.group
		    	# 		# console.log "className", @
		    	# 		# console.log "App.MapApp.Show.Controller.showView.list",App.MapApp.Show.Controller.showView.list
		    	# 	tagName: 'span'
		    	# 	ui: 
		    	# 		'elems': 'span'
		    	# 	events:
		    	# 		'mouseover @ui.elems': 'mouseoverElems'

		    	# 	mouseoverElems: (e) ->
		    	# 		console.log "mouseoverElems", e
		    	# 	onShow: ->
		    	# )
		    	# if @biosFetched is undefined
		    	# 	$.ajax "/biosby/#{d}",
		    	# 		type: 'GET'
		    	# 		dataType: 'json'
		    	# 		error: (jqXHR, textStatus, errorThrown) ->
		    	# 		success: (data, textStatus, jqXHR) =>
		    	# 			$el = $('#bios')
		    	# 			@biosTextResults = data
		    	# 			console.log "data", data, "@biosTextResults", @biosTextResults
		    	# 			L.DomUtil.get(@Controller.showView._bios_domEl).innerHTML = "" 
		    	# 			aBioView = new biosView(collection: bioCollection)
		    	# 			aBioView.render()
		    	# 			# L.DomUtil.get(@Controller.showView._bios_domEl).innerHTML += "#{@biosTextResults[0].__text}"
		    	# 			console.log "aBioView", aBioView.el
		    	# 			_domEl = L.DomUtil.get(@Controller.showView._bios_domEl)
		    	# 			_domEl.innerHTML += aBioView.el.innerHTML
		    	# 			console.log "_domEl", $(_domEl).children()
		    	# 			for each in $('.bioelement').children()
		    	# 				console.log "each", each
		    	# 				each.onmouseover = each.onmousedown = each.ondblclick = L.DomEvent.stopPropagation
		    	# else
		    	# 	console.log "else notheing"
		    	return

			
	App.BioApp.Show.Controller

