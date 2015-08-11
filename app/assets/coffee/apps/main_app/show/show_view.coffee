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
				$(e.target).animate({
					opacity: 0.5
				}, 1500, =>
					console.log "e.target.id", e.target.id
					App.execute("highlightNode", e.target.id)
					App.execute("showBio", e.target.id)
				)
				$(e.target).css('cursor','pointer').css("color", "black").css("background-color", "gray")
				# console.log "mouseoverNames"
				# console.log @, this
			mouseoutNames: (e)->
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
			onBeforeRender: ->
				@$el.css('height', "800").css("list-style-type", "none").css('overflow', 'scroll')
				console.log "onBeforeRender"
			onShow: ->
				$(document).ready =>
					console.log "onShow", @collection
					# @data = _.map @collection.models, (key, value) =>
						# _.map key.attributes, (key, value) =>
							# value
					# console.log "main view @model", @model, @data
					biosRegion = $("#bios-region")
					b_el = $("#main-region")
					btterflyRegion = b_el
					$el = biosRegion
					_textDomEl = L.DomUtil.create('div', 'container paratext-info')
					_el = L.DomUtil.create('svg', 'svg')
					biosRegion.append _textDomEl
					L.DomUtil.enableTextSelection(_textDomEl)  
					_textDomObj = $(L.DomUtil.get(_textDomEl))
					inWidth = $el[0].clientWidth/5
					_textDomObj.css('width', $el[0].clientWidth)
					_textDomObj.css('height', "800")
					_textDomObj.css('background-color', 'none')
					_textDomObj.css('overflow', 'auto')
					L.DomUtil.setOpacity(L.DomUtil.get(_textDomEl), .8)
					color = d3.scale.category10()
					_d3text = d3.select(".paratext-info"
					).append("ul"
					).style("list-style-type", "none"
					).style("padding-left", "0px"
					).style('overflow', 'visible'
					).attr("id", "bios-list"
					).attr("width", $el[0].clientWidth).attr("height", $el[0].clientHeight)
					@_d3li = _d3text
					.selectAll("li")
					# .data(@data)
					# .enter()
					.append("li")
					@_d3li.style("font-family", "Gill Sans").style("font-size", "16px")
					.style("line-height", "1")
					.style("border", "0px solid black")
					.style("margin-top", "20px")
					.style("padding-right", "20px")
					.style("padding-left", "40px")
					.attr("id", (d, i) =>
						return "line-#{i}" 
					).on("mouseover", (d) ->
						$(this).css('cursor','pointer')
					).on("click", (d,i) ->
						L.DomEvent.disableClickPropagation(this) 
						d3.select(this).transition().duration(0).style("color", "black").style("background-color", (d, i) ->
							"white"
						).style "opacity", 1
						d3.select(this).transition().duration(1000).style("color", "rgb(72,72,72)").style("background-color", (d, i) =>
							id = d3.select(this).attr("id").replace("line-", "")
							return color(1) # color(id)
						).style("opacity", 1)					          
						return
					).append("text").text((d,i) =>
						@_leafletli = L.DomUtil.get("line-#{i}")
						timeout = undefined
						L.DomEvent.addListener @_leafletli, 'mouseover', (e) =>
							d3.selectAll(@_d3li[0]).style("color", "black").style("background-color", "white"
							).style "opacity", 1
							timeout = 0
							timeout = setTimeout(->
								if timeout isnt 0 
									timeout = 0
									App.execute("highlightNode", d)
									App.execute("showBio", d)
									
							, 1600)
							App.navigate "#/location/", trgigger: true
							return 
						, ->
							return
							e.stopPropagation()
						d
					).style("font-family", "Gill Sans").style("font-size", "14px").style("color", "black").transition().duration(1).delay(1).style("opacity", 1)
					projection = d3.geo.polyhedron.waterman().rotate([20, 0]).scale(150).translate([btterflyRegion[0].clientWidth / 2, 400]).precision(.1)
					pathG = d3.geo.path().projection(projection)
					graticule = d3.geo.graticule()
					clicks = []
					gradient = ['black', 'red']
					color = d3.scale.linear().domain([0, 3]).range(gradient)
					svg = d3.select('#main-region').append('svg').attr('width', btterflyRegion[0].clientWidth).attr('height', 800)
					defs = svg.append('defs')
					land = undefined
					mouseovered = (d) ->
						console.log "mouseovered"
					clicked = (d) ->
						p = d3.select(this)
						clicks[d.id]++
						domain = [d3.min(clicks), d3.max(clicks)]
						color.domain domain
						land.filter('.land').style 'fill', (d) ->
							color clicks[d.id]
						timeout = 0
						timeout = setTimeout(->
							if timeout isnt 0 
								timeout = 0
								console.log "d", d
								App.execute("showBio", [d.source])
								App.execute("highlightNode", [d.source])
						, 1600)
						App.navigate "#/location/", trgigger: true
						return 
					defs.append('path').datum(type: 'Sphere').attr('id', 'sphere').attr 'd', pathG
					defs.append('clipPath').attr('id', 'clip').append('use').attr 'xlink:href', '#sphere'
					svg.append('use').attr('class', 'stroke').attr 'xlink:href', '#sphere'
					svg.append('use').attr('class', 'fill').attr 'xlink:href', '#sphere'
					svg.append('path').datum(graticule).attr('class', 'graticule').attr('clip-path', 'url(#clip)').attr 'd', pathG
					d3.json 'world-50m.json', (error, world) ->
						polys = topojson.feature(world, world.objects.countries).features
						polys.forEach (d) ->
							clicks[d.id] = 0
							return
						land = svg.selectAll('path').data(polys)
						land.enter().insert('path', '.graticule').attr('class', 'land').attr('clip-path', 'url(#clip)').style('fill', (d) ->
							color clicks[d.id]
						).attr('d', pathG).on('click', clicked).on('mouseover', mouseovered)
						textResponse = $.ajax
							url: "/artistsbygroup/1"
							success: (result) =>
								result
						$.when(textResponse).done (artists) =>
          					console.log "ar]", artists
          					svg.selectAll('path').data(artists).enter().append('circle', '.pin').attr('r', 4).attr('fill', 'white').attr('transform', (d) ->
          						if d.long != "NA"
	          						'translate(' + projection([
	          							d.long
	          							d.lat
	          						]) + ')'
          						# ).on('mouseover', mouseovered
          						).on('click', clicked).on('mouseover', (d) ->
          							xPosition = d3.select(this).attr('x')
          							yPosition = d3.select(this).attr('y')
          							#Update the tooltip position and value
          							d3.select('#tooltip').style('left', d3.event.pageX + 'px').style('top', d3.event.pageY - 90 + 'px').select('#-label'
          							).html('<strong>' + 'Location: ' + d.target + '</strong>' + '<br/>' + 'View Artist: ' + d.source

          							#Show the tooltip
          							)
          							d3.select('#tooltip').classed 'hidden', false
          							return
          						).on 'mouseout', ->
          							#Hide the tooltip
          							d3.select('#tooltip').classed 'hidden', true
          							return
							return
					d3.select(self.frameElement).style 'height', btterflyRegion[0].clientHeight + 'px'
		)
		# View.ShowView = Marionette.CollectionView.extend(
		# 	template: showTpls
		# 	itemView: View.ShowView
  #       	itemViewContainer: "tbody"
		# 	)
		

	App.MainApp.View