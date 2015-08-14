define ["js/app", "tpl!js/apps/main_app/show/templates/show_view.tpl", "tpl!js/apps/main_app/show/templates/show_views.tpl"], (App, showTpl, showTpls) ->
	App.module "MainApp.View", (View, App, Backbone, Marionette, $, _) ->

		View.ShowView = Marionette.ItemView.extend(
			template: showTpl
			# tagName: "li"            
			# id: 'bios'
			# $el: $('#bios')
			ui: 'name': 'li'
			$el: $('li')
			events:
				'mouseover @ui.name':'mouseoverNames'
				'mouseout @ui.name':'mouseoutNames'
			mouseoverNames: (e)->
				console.log "e", e
				@timeout = setTimeout(=>
					# @timeout = 0
					if @timeout > 75
						App.execute("highlightNode", e.target.id)
						App.execute("showBio", e.target.id)
					return
				, 1600, (e) =>
					return
				)
				$(e.target).css('cursor','pointer').css("color", "black").css("background-color", "gray")
			mouseoutNames: (e)->
				@timeout = 0
				$(e.target).animate({
					opacity: 1
				}, 500)
				$(e.target).css('cursor','default').css("color", "black").css("background-color", "white")
			onBeforeRender: ->
				@$el
					.css("font-family", "Gill Sans"
					).css("line-height", "1.5"
					).css("border", "0px solid black"
					).css("font-size", "16px"
					).css("margin-top", "20px"
					).css("padding-right", "20px"
					).css("padding-left", "40px")
			onShow: ->

		)
		View.ShowViews = Marionette.CollectionView.extend(
			itemView: View.ShowView
			itemViewContainer: "ul"
			template: showTpls
			id: 'bios-list'
			$el: $('#bios-list')
			ui: 'list':'ul'
			initialize: ->
				@on 'update', (view, model)->
					console.log "indide the view initialize update", @
			onBeforeRender: ->
				@$el.css('height', "700").css("list-style-type", "none").css('overflow', 'scroll')
				@biosRegion = $("#bios-region")
				# $(@biosRegion).animate({
				# 	 "left": "-=250px" 
				# 	 "opacity"
				# }, "slow" , =>
				# 	console.log "@biosRegion", @biosRegion
				# )
				# $(@biosRegion.next()).animate({
				# 	 "left": "-=100px" 
				# 	 "opacity"
				# }, "slow" , =>
				# 	console.log "@biosRegion", @biosRegion
				# )
				# console.log "collection", @collection
				# newCollction = @collection.where("name": 'Abbas Akhavan')
				# @collection = new App.Entities.ArtistSourceCollection(newCollction)
				console.log "onBeforeRender"
			collectionEvents: ->
				"add": "itemAdded"
			itemAdded: ->
				console.log "itemAdded"
			onShow: ->
				# $(document).ready =>
				# 	biosRegion = @biosRegion
				# 	b_el = $("#main-region")
				# 	btterflyRegion = b_el
				# 	projection = d3.geo.polyhedron.waterman().rotate([20, 0]).scale(150).translate([btterflyRegion[0].clientWidth / 2, 400]).precision(.1)
				# 	pathG = d3.geo.path().projection(projection)
				# 	graticule = d3.geo.graticule()
				# 	clicks = []
				# 	gradient = ['black', 'red']
				# 	color = d3.scale.linear().domain([0, 3]).range(gradient)
				# 	svg = d3.select('#main-region').append('svg').attr('width', btterflyRegion[0].clientWidth).attr('height', 800)
				# 	defs = svg.append('defs')
				# 	land = undefined
				# 	mouseovered = (d) ->
				# 		console.log "mouseovered"
				# 	clicked = (d) =>
				# 		p = d3.select(this)
				# 		clicks[d.id]++
				# 		domain = [d3.min(clicks), d3.max(clicks)]
				# 		color.domain domain
				# 		land.filter('.land').style 'fill', (d) ->
				# 			color clicks[d.id]
				# 		timeout = 0
				# 		timeout = setTimeout(=>
				# 			if timeout isnt 0 
				# 				timeout = 0
				# 				console.log "d", d
				# 				# $(@biosRegion).animate({
				# 				# 	 "left": "+=250px" 
				# 				# 	 "opacity"
				# 				# }, "slow" , =>
				# 				# )
				# 				# $(@biosRegion.next()).animate({
				# 				# 	 "left": "+=100px" 
				# 				# 	 "opacity"
				# 				# }, "slow" , =>
				# 				# )
				# 		, 1600, =>
				# 			App.execute("showBio", [d.source])
				# 			App.execute("highlightNode", [d.source])
				# 		)
				# 		App.navigate "#/location/", trgigger: true
				# 		return 
				# 	defs.append('path').datum(type: 'Sphere').attr('id', 'sphere').attr 'd', pathG
				# 	defs.append('clipPath').attr('id', 'clip').append('use').attr 'xlink:href', '#sphere'
				# 	svg.append('use').attr('class', 'stroke').attr 'xlink:href', '#sphere'
				# 	svg.append('use').attr('class', 'fill').attr 'xlink:href', '#sphere'
				# 	svg.append('path').datum(graticule).attr('class', 'graticule').attr('clip-path', 'url(#clip)').attr 'd', pathG
				# 	d3.json 'world-50m.json', (error, world) ->
				# 		polys = topojson.feature(world, world.objects.countries).features
				# 		polys.forEach (d) ->
				# 			clicks[d.id] = 0
				# 			return
				# 		land = svg.selectAll('path').data(polys)
				# 		land.enter().insert('path', '.graticule').attr('class', 'land').attr('clip-path', 'url(#clip)').style('fill', (d) ->
				# 			color clicks[d.id]
				# 		).attr('d', pathG).on('click', clicked).on('mouseover', mouseovered)
				# 		textResponse = $.ajax
				# 			url: "/artistsbygroup/1"
				# 			success: (result) =>
				# 				result
				# 		$.when(textResponse).done (artists) =>
    #       					console.log "ar]", artists
    #       					svg.selectAll('path').data(artists).enter().append('circle', '.pin').attr('r', 4).attr('fill', 'white').attr('transform', (d) ->
    #       						if d.long != "NA"
	   #        						'translate(' + projection([
	   #        							d.long
	   #        							d.lat
	   #        						]) + ')'
    #       						# ).on('mouseover', mouseovered
    #       						).on('click', clicked).on('mouseover', (d) ->
    #       							xPosition = d3.select(this).attr('x')
    #       							yPosition = d3.select(this).attr('y')
    #       							#Update the tooltip position and value
    #       							d3.select('#tooltip').style('left', d3.event.pageX + 'px').style('top', d3.event.pageY - 90 + 'px').select('#-label'
    #       							).html('<strong>' + 'Location: ' + d.target + '</strong>' + '<br/>' + 'View Artist: ' + d.source

    #       							#Show the tooltip
    #       							)
    #       							d3.select('#tooltip').classed 'hidden', false
    #       							return
    #       						).on 'mouseout', ->
    #       							#Hide the tooltip
    #       							d3.select('#tooltip').classed 'hidden', true
    #       							return
				# 			return
				# 	d3.select(self.frameElement).style 'height', btterflyRegion[0].clientHeight + 'px'
		)
		# View.ShowView = Marionette.CollectionView.extend(
		# 	template: showTpls
		# 	itemView: View.ShowView
  #       	itemViewContainer: "tbody"
		# 	)
		

	App.MainApp.View