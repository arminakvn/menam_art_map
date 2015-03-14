define ["js/app", "tpl!js/apps/org_app/show/templates/show_view.tpl"], (App, showTpl) ->
  App.module "OrgApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.ShowView = Marionette.ItemView.extend(
      template: showTpl
      id:"organization-region"
      tagName:"div"
      onShow: ->
        require ["js/entities/artist"], =>
          textResponse = $.ajax
                        url: "/artists"
                        success: (artists) =>
                          @collection = App.request "set:artist", artists
                          # @$el = $('main-region')
                          console.log "artists", artists
                          id = 0
                          @artistNodes = [] 
                          nodes = []
                          for artist in @collection.models
                            nodes.push artist.attributes
                            # make a list of artist names when data arrives and keep it
                            @artistNodes.push {'name' :artist.attributes.source, 'id': id, 'group': artist.attributes.group}
                            id = id + 1
                          # using the data to create links and nodes in format
                          console.log "nodes", nodes
                          _links = nodes
                          _links.sort (a, b) ->
                              if a.source > b.source
                                1
                              else if a.source < b.source
                                -1
                              else
                                if a.target > b.target
                                  return 1
                                if a.target < b.target
                                  -1
                                else
                                  0
                          i = 0
                          while i < _links.length
                            if i != 0 and _links[i].source == _links[i - 1].source and _links[i].target == _links[i - 1].target
                              _links[i].linknum = _links[i - 1].linknum + 1
                            else
                              _links[i].linknum = 1
                            i++
                          console.log "_links", _links                          
                          _nodes = {}
                          # Compute the distinct nodes from the links.
                          _links.forEach (link) ->
                            link.source = _nodes[link.source] or (_nodes[link.source] = name: link.source, value: 1)
                            link.target = _nodes[link.target] or (_nodes[link.target] = {name: link.target, group: link.group, lat: link.lat, long: link.long, value: 1})
                            return
                          d3.values((_nodes)).forEach (sourceNode) =>
                            _links.forEach (link) => 
                              if link.source.name == sourceNode.name and link.target.name != sourceNode.name
                                link.target.value += 1
                              return
                            return
                          height = 1100
                          padding = 1.5
                          color = d3.scale.category20()
                          @_nodes = nodes = _nodes
                          @_links = links = _links
                          console.log "_links", _links
                          n = d3.values((_nodes)).length
                          console.log "number of nodes:", n
                          m = 3
                          # clusters = new Array(m)
                          # _nodes = d3.range(n).map(->
                          #   i = Math.floor(Math.random() * m)
                          #   r = Math.sqrt((i + 1) / m * -Math.log(Math.random())) * maxRadius
                          #   d = 
                          #     cluster: i
                          #     radius: r
                          #   if !clusters[i] or r > clusters[i].radius
                          #     clusters[i] = d
                          #   d
                          # )
                          # svg = d3.select('body').append('svg').attr('width', width).attr('height', height)
                          width = $("#organization-region")[0].clientWidth
                          svg = vis = @vis = d3.select('#organization-region').append('svg:svg').attr('width', width).attr('height', width)
                          force = @force = d3.layout.force(
                          ).gravity(.6
                          ).linkDistance(50
                          ).charge(-150
                          ).linkStrength(1
                          ).friction(0.9
                          ).size([
                            width
                            height
                          ]).on("tick", tick)
                          @nodes = @force.nodes(d3.values(_nodes))
                          @links = @force.links()
                          link = svg.selectAll('.link').data(_links)
                          link.enter().insert("line", ".node").attr("class", "link").style("stroke","lightgray").style("stroke-width", (d, i) -> 
                              return Math.sqrt(d.target.value)
                            ).style("opacity", 0.3)
                          link.exit().remove()
                          
                          node = @vis.selectAll('g.node'
                          ).data(d3.values(_nodes), (d) ->
                            d.name
                          )
                          @color = d3.scale.category10()
                          color = @color
                          _artistNodes = @_nodes
                          nodes = _nodes
                          nodeEnter = node.enter().append('g').attr('class', 'node').attr("x", 14).attr("dy", "5.35em").call(@force.drag)
                          # nodeEnter.attr("class", "leaflet-zoom-hide")
                          nodeEnter.append('circle').property("id", (d, i) => "node-#{i}").attr('r', (d) ->
                            if d.group == 2
                              return Math.sqrt(d.value) * 2
                            else
                              return 2
                          ).attr('x', '-1px').attr('y', '10px').attr('width', '4px').attr('height', '4px'
                          ).style("stroke", "none"
                          ).style("opacity", 0.6).style('fill', (d) =>
                            return @color(d.group)
                          ).on('mouseover', (d, i) ->
                            # OrgGraph.Controller.highlightNodesBy(d)
                            # d3.select(this).select('circle').transition().duration(750).attr 'opacity', 0.7
                            # d3.select(this).select('text').transition().duration(750).attr('opacity', 0.7).style 'font-size', '26px'
                            return
                          ).on('mouseout', (d,i) ->
                            # OrgGraph.Controller.resetHighlightNodesBy()
                            # d3.select(this).select('circle').transition().duration(750).attr 'r', 10
                            # d3.select(this).select('text').transition().duration(750).style 'font-size', '10px'
                            return
                          ).on('touchstart', (d, i) ->
                            # d3.select(this).select('circle').transition().duration(750).attr 'r', 12
                            # d3.select(this).select('text').transition().duration(750).style 'font-size', '20px'
                            return
                          ).on('touchend', (d,i) ->
                            # d3.select(this).select('circle').transition().duration(750).attr 'r', 5
                            # d3.select(this).select('text').transition().duration(750).style 'font-size', '10px'
                            return
                          ).call(force.drag
                          
                          )

                          node.exit().remove()

                          # force = d3.layout.force().nodes(nodes).links(links).size([
                          #   width
                          #   height
                          # ]).linkDistance(60).charge(-500).linkStrength(0.7).gravity(0.3)
                          # link = svg.selectAll('.link').data(force.links()).enter().append('line').attr('class', 'link').style('stroke', 'lightgray').style('stroke-width', (d) ->
                            # Math.sqrt d.value
                          # )
                          # node = svg.selectAll('.node').data(force.nodes()).enter().append('g').attr('class', 'node').on('mouseover', mouseover).on('mouseout', mouseout).on('touchstart', mouseover).on('touchend', mouseout).call(force.drag).on('dblclick', connectedNodes)

                          zoom = d3.behavior.zoom()
                          

                          viewCenter = []
                          viewCenter[0] = -1 * zoom.translate()[0] + 0.5 * width / zoom.scale()
                          viewCenter[1] = -1 * zoom.translate()[1] + 0.5 * height / zoom.scale()
                          # graphTransform = force.attribute("transform")
                          # console.log graphTransform
                          node.transition().duration(750).delay((d, i) ->
                            i * 5
                          ).attrTween 'r', (d) ->
                            i = d3.interpolate(0, d.radius)
                            (t) ->
                              d.radius = i(t)
                          
                          # Move d to be adjacent to the cluster node.
                          
                          tick = (e) ->
                            # console.log e.alpha
                            link.attr('x1', (d) ->
                              if d.source.value
                                e.alpha * 100/d.source.value + d.source.x + 100
                              else
                                d.source.x + 400
                            ).attr('y1', (d) ->
                              if d.source.value
                                e.alpha * 100/d.source.value + d.source.y
                              else
                                d.source.y
                            ).attr('x2', (d) ->
                              if d.target.value 
                                d.target.x  - 100 - (e.alpha * Math.sqrt(d.target.value))
                              else
                                d.target.x  - 100 
                            ).attr 'y2', (d) ->
                              if d.value 
                                d.target.y - 100 - (e.alpha * Math.sqrt(d.target.value))
                              else
                                d.target.y
                            # node.each(cluster(10 * e.alpha * e.alpha)).each(collide(.5)).attr('cx', (d) ->
                              # d.x
                            # ).attr 'cy', (d) ->
                              # d.y
                            node.attr('transform', (d) ->
                              # console.log d
                              if d.group == 1
                                if d.value
                                  x = e.alpha * 100/d.value + d.x + 100
                                  y = e.alpha * 100/d.value + d.y
                                else
                                  x = d.x + 400
                                  y = d.y
                                'translate(' + x + ',' + y + ')'
                              else 
                                if d.value
                                  x = d.x - e.alpha * 100/d.value - 100
                                  y = d.y - e.alpha * 100/d.value
                                else
                                  x = d.x - 100
                                  y = d.y
                                'translate(' + x + ',' + y + ')'
                              
                            )
                            return


                          @force.on('tick', tick).start()

                            #do it

                              
                          optArray = []
                          j = 0
                          nodes =  d3.values(_nodes)
                          while j < nodes.length - 1
                            optArray.push nodes[j].name
                            j++
                          optArray = optArray.sort()
                          # $ ->
                          #   $('#search').autocomplete source: optArray
                          #   return
                          #SUBNET HIGHLIGHT
                          #code from http://www.coppelia.io/2014/07/an-a-to-z-of-extra-features-for-the-d3-force-layout/
                          #Toggle stores whether the highlighting is on
                          # @toggle = 0
                          toggle = 0
                          #Create an array logging what is connected to what
                          linkedByIndex = {}
                          j = 0
                          while j < nodes.length
                            linkedByIndex[j + ',' + j] = 1
                            j++
                          links.forEach (d) ->
                            linkedByIndex[d.source.index + ',' + d.target.index] = 1
                            return

                          

                          # node.append('circle').style('fill', (d) ->
                          #   color d.group
                          # ).attr 'r', 5
                          node.append('text').style("font-family", "Gill Sans").attr('fill', (d) ->
                            return d3.lab(color(d.group)).darker(2)
                          ).attr("opacity", 0.3).attr('x', 14).attr('dy', '.35em').text (d) ->
                            d.name

                          # ---
                          # generated by js2coffee 2.0.1
                          node.on('click', (d, i) ->
                            
                            neighboring = (a, b) ->
                              linkedByIndex[a.index + ',' + b.index]
                            if toggle == 0
                              App.OrgApp.Show.Controller.highlightNodesBy(d)
                              #Reduce the opacity of all but the neighbouring nodes
                              d = d3.select(this).node().__data__
                              node.selectAll("circle").transition(100).style 'opacity', (o) ->
                                if neighboring(d, o) | neighboring(o, d) then 1 else 0.1
                              node.selectAll("text").transition(100).style('opacity', (o) ->
                                if neighboring(d, o) | neighboring(o, d) then 1 else 0.2
                              ).style('font-size', (o) ->
                                if neighboring(d, o) | neighboring(o, d) then 20 else 12
                              )
                              link.transition(100).style 'opacity', (o) ->
                                if d.index == o.source.index | d.index == o.target.index then 1 else 0.1
                              toggle = 1
                            else
                              #Put them back to opacity=1
                              node.selectAll("circle").transition(100).style 'opacity', 0.6
                              link.transition(100).style 'opacity', 1
                              node.selectAll("text").transition(100).style('opacity',  0.3
                              ).style('font-size', 14
                              )
                              App.OrgApp.Show.Controller.resetHighlightNodesBy(d)
                              toggle = 0
                            return
                          )
                            
                          App.OrgApp.Show.Controller._links = _links
                          App.OrgApp.Show.Controller._nodes = _nodes
                          App.OrgApp.Show.Controller.vis = vis

                          searchNode = () ->
                            #find the node
                            # selectedVal = document.getElementById('search').value
                            node = @vis.selectAll('g.node')
                            if selectedVal == 'none'
                              node.style('stroke', 'white').style 'stroke-width', '1'
                            else
                              selected = node.filter((d, i) ->
                                d.name != selectedVal
                              )
                              selected.style 'opacity', '0'
                              link = svg.selectAll('.link')
                              link.style 'opacity', '0'
                              d3.selectAll('.node, .link').transition().duration(3000).style 'opacity', 1
                            return
    )
  App.OrgApp.View