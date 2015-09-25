define ["js/app", "tpl!js/apps/main_app/show/templates/show_view.tpl", "tpl!js/apps/main_app/show/templates/show_views.tpl", "tpl!js/apps/main_app/show/templates/spider_view.tpl"], (App, showTpl, showTpls, spiderTpl) ->
	App.module "MainApp.View", (View, App, Backbone, Marionette, $, _) ->

		View.SpiderView = Marionette.CollectionView.extend(
			template: spiderTpl
			id: 'bios-list'
			$el: $('#bios-list')
		)

		View.ShowView = Marionette.ItemView.extend(
			template: showTpl
			tagName: "div"            
			# $el: $('#bios')
			ui: 
				'name': 'li'
			$el: $('li')
			className: 'artistsList'
			events:
				# 'mouseenter @ui.name':'mouseEnterNames'
				# 'hover @ui.name':'mouseoverNames'
				'mouseover @ui.name':'mouseoverNames'
				'mouseout @ui.name':'mouseoutNames'
				'click @ui.name' : 'clickNames'
			modelEvents:
				'change' : 'render'
			# mouseoverDots: (e) ->
			mouseoverNames: (e)->
				console.log "e", e
				@timeout = setTimeout(=>
					if @timeout > 75
						App.execute("showBio", e.target.id)
						console.log "$('bioTriggerd')", $('.bioTriggerd')
						$('.bioTriggerd').removeClass('bioTriggerd') 
						$(e.target).addClass('highlighted bioTriggerd')
						# App.execute("highlightNode", e.target.id)
						@timeout=0


					return
				, 300, (e) =>
					return
				)
				$(e.target).css('cursor','pointer')
				$(e.target).addClass('highlighted')

			mouseoutNames: (e)->
				@timeout = 0
				$(e.target).animate({
					opacity: 1
				}, 500)
				$(e.target).css('cursor','default')
				$(e.target).removeClass('highlighted')
				$(e.target).removeClass('bioTriggerd')
				# App.execute("hideBio")
			clickNames: (e) ->
				App.navigate "#/organization/#{e.target.id}", trgigger: true
			onBeforeRender: ->
				@$el.css("opacity", 0)
			
			onBeforeDestroy: ->
				@$el.animate({
					 "opacity": 0
				}, 2000 , =>
				)
			onShow: ->
				$(".hoverdots").hide()
				@$el.animate({
					 "opacity": 1
				}, 1000 , =>
				)

		)
		View.ShowViews = Marionette.CompositeView.extend(
			itemView: View.ShowView
			template: showTpls
			id: 'bios-list'
			$el: $('#bios-list')
			ui: 
				'list':'ul'
				'divs': 'div'
				'navigator': 'span'
			events:
				'mouseover @ui.divs':'mouseEnterDivs'
				'mouseover @ui.navigator' : 'mouseoverNavigator'
				'click @ui.navigator' : 'clickNavigator'
				# 'mouseout @ui.divs':'mouseoutDivs'
				# 'mouseover @ui.dots':'mouseoverNavigator'
			
			modelEvents:
				"model:change": "doSomething"
			  
			doSomething: ->
				console.log "doSomething"
			# mouseEnterDivs: (e) ->
			# 	$(".hoverdots").show().fadeIn()
			# 	console.log "divs", e.target, e
				# console.log "$(e.target)..children('span')", $(e.target).children('span')
				# if $(e.target).children('span').css('visibility') == 'hidden'
				# 	$(e.target).children('span').css('visibility','visible')
				# else
				# 	$(e.target).children('span').css('visibility','hidden')
				# $(e.target).next().toggleClass("visible")

			# modelEvents:
			# 	'change' : 'fieldsChanged'
			mouseoverNavigator: (e) ->
				$(e.target).css('cursor','pointer')
				
				console.log "mouse over navigator"
			clickNavigator: (e) ->
				App.MainApp.Show.Controller.updateView('all')
				App.MapApp.Show.Controller.resetMapHighlights()
			mouseoutDivs: (e)->
				$(".hoverdots").show().fadeOut()
				console.log "mouseoutDivs"
				console.log "divs", e.target
				# $(e.target).next().removeClass("visible")
				# $(e.target).next().toggleClass("artisthover")
			initialize: ->
				Marionette.bindEntityEvents(this, this.model, this.modelEvents)
			onBeforeRender: ->
				@$el.css('height', "700").css("list-style-type", "none").css('overflow', 'scroll')
				@biosRegion = $("#bios-region")
			# 	$(@biosRegion).animate({
			# 		 "left": "-=250px" 
			# 		 "opacity"
			# 	}, "slow" , =>
			# 	)
			# 	$(@biosRegion.next()).animate({
			# 		 "left": "-=150px" 
			# 		 "opacity"
			# 	}, "slow" , =>
			# 	)
			# onBeforeDestroy: ->
				console.log "onBeforeDestroy"
			onBeforeRemoveChild: ->
				console.log "onBeforeRemoveChild"
			buildChildView: (child, ChildViewClass, childViewOptions) ->
			  # build the final list of options for the childView class
			  options = _.extend({ model: child }, childViewOptions)
			  # create the child view instance
			  view = new ChildViewClass(options)
			  # return it
			  view
			onBeforeAddChild: ->
				console.log "onBeforeAddChild"

			onShow: ->
				$(document).ready =>
					console.log "@model", @model
					biosRegion = @biosRegion
					b_el = $("#main-region")
					btterflyRegion = b_el
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
					clicked = (d) =>
						p = d3.select(this)
						clicks[d.id]++
						domain = [d3.min(clicks), d3.max(clicks)]
						color.domain domain
						land.filter('.land').style 'fill', (d) ->
							color clicks[d.id]
						timeout = 0
						timeout = setTimeout(=>
							if timeout isnt 0 
								timeout = 0
								console.log "d", d
								# $(@biosRegion).animate({
								# 	 "left": "+=250px" 
								# 	 "opacity"
								# }, "slow" , =>
								# )
								# $(@biosRegion.next()).animate({
								# 	 "left": "+=150px" 
								# 	 "opacity"
								# }, "slow" , =>
								# )
						, 1600, =>
							App.execute("showBio", [d.source])
							App.execute("highlightNode", [d.source])
						)
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