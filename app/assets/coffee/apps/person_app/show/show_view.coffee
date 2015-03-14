define ["js/app", "tpl!js/apps/person_app/show/templates/show_view.tpl"], (App, showTpl) ->
	App.module "PersonApp.View", (View, App, Backbone, Marionette, $, _) ->

		View.ShowView = Marionette.ItemView.extend(
			template: showTpl
			id: "person-region"
			tagName: "div"

			onShow: ->
				textResponse = $.ajax
					url: "/nodes"
					success: (nodes) =>
						width = 1200
						height = 700
						color = d3.scale.category20()
						linksResponse = $.ajax
							url: "/links"
							success: (links) =>
								svg = d3.select('#person-region').append('svg').attr('width', width).attr('height', height)
								force = d3.layout.force().nodes(nodes).links(links).size([width, height]
								).linkDistance(60
								).charge(-500
								).linkStrength(0.7
								).gravity(0.3).on('tick', tick
								).start()
								link = svg.selectAll('.link'
								).data(force.links()
								).enter().append('line'
								).attr('class', 'link'
								).style('stroke', 'lightgray'
								).style('stroke-width', (d) -> Math.sqrt d.value)
								node = svg.selectAll('.node'
								).data(force.nodes()).enter().append('g'
								).attr('class', 'node'
								).on('mouseover', mouseover
								).on('mouseout', mouseout
								).on('touchstart', mouseover
								).on('touchend', mouseout
								).call(force.drag).on('click', connectedNodes)

								tick = ->
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

								mouseover = ->
								  d3.select(this).select('circle').transition().duration(750).attr 'r', 12
								  d3.select(this).select('text').transition().duration(750).style 'font-size', '20px'
								  return

								mouseout = ->
								  d3.select(this).select('circle').transition().duration(750).attr 'r', 5
								  d3.select(this).select('text').transition().duration(750).style 'font-size', '10px'
								  return

								searchNode = ->
								  `var node`
								  #find the node
								  selectedVal = document.getElementById('search').value
								  node = svg.selectAll('.node')
								  if selectedVal == 'none'
								    node.style('stroke', 'white').style 'stroke-width', '1'
								  else
								    selected = node.filter((d, i) ->
								      `var link`
								      d.name != selectedVal
								    )
								    selected.style 'opacity', '0'
								    link = svg.selectAll('.link')
								    link.style 'opacity', '0'
								    d3.selectAll('.node, .link').transition().duration(3000).style 'opacity', 1
								  return

								#This function looks up whether a pair are neighbours  

								neighboring = (a, b) ->
								  linkedByIndex[a.index + ',' + b.index]

								#do it

								connectedNodes = ->
								  if toggle == 0
								    #Reduce the opacity of all but the neighbouring nodes
								    d = d3.select(this).node().__data__
								    node.style 'opacity', (o) ->
								      if neighboring(d, o) | neighboring(o, d) then 1 else 0.1
								    link.style 'opacity', (o) ->
								      if d.index == o.source.index | d.index == o.target.index then 1 else 0.1
								    toggle = 1
								  else
								    #Put them back to opacity=1
								    node.style 'opacity', 1
								    link.style 'opacity', 1
								    toggle = 0
								  return

								node.append('circle').style('fill', (d) -> color d.group).attr 'r', 5
								node.append('text').attr('x', 14).attr('dy', '.35em').text (d) ->
								  d.name
								#SEARCH BOX 
								#code from http://www.coppelia.io/2014/07/an-a-to-z-of-extra-features-for-the-d3-force-layout/
								optArray = []
								i = 0
								while i < nodes.length - 1
								  optArray.push nodes[i].name
								  i++
								optArray = optArray.sort()
								#SUBNET HIGHLIGHT
								#code from http://www.coppelia.io/2014/07/an-a-to-z-of-extra-features-for-the-d3-force-layout/
								#Toggle stores whether the highlighting is on
								toggle = 0
								#Create an array logging what is connected to what
								linkedByIndex = {}
								i = 0
								while i < nodes.length
								  linkedByIndex[i + ',' + i] = 1
								  i++
								links.forEach (d) ->
								  linkedByIndex[d.source.index + ',' + d.target.index] = 1
								  return

    )

	App.PersonApp.View