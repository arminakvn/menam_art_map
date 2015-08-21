define ["js/app", "tpl!js/apps/person_app/show/templates/show_view.tpl"], (App, showTpl) ->
	App.module "PersonApp.View", (View, App, Backbone, Marionette, $, _) ->
		View.ShowView = Marionette.Layout.extend(
			template: showTpl
			id: "person-region"
			tagName: "div"
			initialize: ->	
			onShow: ->
				@nodes = []
				@collection.each (artist) =>
		          @nodes.push artist.attribultes
		        @links = []
		        for artist in App.PersonLinkCollection.models
		          @links.push artist.attributes
		        i = 0
		        @optArray = []
				while i < @nodes.length - 1
				  @optArray.push @nodes[i].name
				  i++
				@optArray = @optArray.sort()
				App.PersonApp.Show.Controller.toggle = 0	
				@width = @el.clientWidth
				@height = @el.clientHeight		
				@height = 1100 if @height < 800
				color = d3.scale.category20()
				@svg = d3.select('#person-region').append('svg').attr('width', @width).attr('height', @height)
				@force = d3.layout.force().nodes(@nodes).links(@links).size([@width, @height]
				).linkDistance(60
				).charge(-500
				).linkStrength(0.7
				).gravity(0.3).start()
				@link = link = @svg.selectAll('.link'
				).data(@force.links()
				).enter().append('line'
				).attr('class', 'link'
				).style('stroke', 'lightgray'
				).style('stroke-width', (d) -> Math.sqrt d.value)
				@node = node = @svg.selectAll('.node'
				).data(@force.nodes()).enter().append('g'
				).attr('class', 'node'
				).on('mouseover', mouseover
				).on('mouseout', mouseout
				).on('touchstart', mouseover
				).on('touchend', mouseout
				).call(@force.drag).on('click', () ->
					d = d3.select(this).node().__data__
					App.PersonApp.Show.Controller.connectedNodes(d)
				)
				@tick = =>
					link.attr('x1', (d) ->
						d.source.x
					).attr('y1', (d) ->
						d.source.y
					).attr('x2', (d) ->
						d.target.x
					).attr 'y2', (d) ->
						d.target.y
					node.attr 'transform', (d) ->
						'translate(' + d.x + ',' + d.y + ')'
					return
				@linkedByIndex = {}
				i = 0
				while i < @nodes.length
					@linkedByIndex[i + ',' + i] = 1
					i++
				@links.forEach (d) =>
					@linkedByIndex[d.source.index + ',' + d.target.index] = 1
					return
				@neighboring = (a, b) =>
					@linkedByIndex[a.index + ',' + b.index]
				mouseover = ->
				  console.log "mouseover"
				  d3.select(this).select('circle').transition().duration(750).attr 'r', 12
				  d3.select(this).select('text').transition().duration(750).style 'font-size', '20px'
				  return
				mouseout = ->
				  d3.select(this).select('circle').transition().duration(750).attr 'r', 5
				  d3.select(this).select('text').transition().duration(750).style 'font-size', '10px'
				  return
				node.append('circle').style('fill', (d) -> color d.group).attr 'r', 5
				node.append('text').attr('x', 14).attr('dy', '.35em').text (d) ->
					d.name
				@force.on('tick', @tick).start()
				App.PersonApp.Show.Controller.node = @node
				App.PersonApp.Show.Controller.link = @link
				App.PersonApp.Show.Controller.connectedNodes= (d) =>	      		
					if App.PersonApp.Show.Controller.toggle == 0
						@node.style 'opacity', (o) =>
							if @neighboring(d, o) | @neighboring(o, d) then 1 else 0.1
						@link.style 'opacity', (o) =>
							if d.index == o.source.index | d.index == o.target.index then 1 else 0.1
						App.PersonApp.Show.Controller.toggle = 1
					else
						@node.style 'opacity', 1
						@link.style 'opacity', 1
						App.PersonApp.Show.Controller.toggle = 0
					return
				@force.resume()

    )
	App.PersonApp.View