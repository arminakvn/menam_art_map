define ["js/app", "tpl!js/apps/org_app/show/templates/show_view.tpl"], (App, showTpl) ->
  App.module "OrgApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.ShowView = Marionette.Layout.extend(
      template: showTpl
      id:"organization-region"
      tagName:"div"
      onDomRefresh:->

      initialize: ->
        # orgbysourceartist
      onShow: ->
        console.log "collection", @collection
        nodes = []
        @collection.models.forEach (model) ->
          nodes.push model.attributes
        # nodes1 = @collection.models.attributes

        # console.log "nodes1", nodes1
        console.log "nodes", nodes
        # for each in nodes1
          # nodes.push each
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
        _nodes = {}
        _links.forEach (link) ->
          link.source = _nodes[link.source] or (_nodes[link.source] = name: link.source, value: 0, group: 0)
          link.target = _nodes[link.target] or (_nodes[link.target] = {name: link.target, group: link.group, lat: link.lat, long: link.long, value: 1})
          return
        d3.values((_nodes)).forEach (sourceNode) =>
          _links.forEach (link) => 
            if link.source.name == sourceNode.name and link.target.name != sourceNode.name
              link.target.value += 1
            return
          return
        t_nodes = _nodes
        t_links = _links
        @draw(t_nodes, t_links)
        @collection.models.forEach (model) =>
          console.log "mosdel", model.attributes.target.name.replace /^\s+|\s+$/g, ""
          updateCollection = $.ajax '/artstsby/'+model.attributes.target.name.replace /^\s+|\s+$/g, "",
            type: 'GET'
            dataType: 'json'
            error: (jqXHR, textStatus, errorThrown) ->
              console.log "error", textStatus, errorThrown
            success: (data, textStatus, jqXHR) =>
                console.log "data!!", data
                # ret = _.map data, (key, value) =>
                #     "target": key.target
                return data
          $.when(updateCollection).done (resB)=> 
                      console.log "updateCollection", resB
                      nodes = []
                      resB.forEach (model) ->
                        nodes.push model
                      # nodes1 = @collection.models.attributes

                      # console.log "nodes1", nodes1
                      console.log "nodes", nodes
                      # for each in nodes1
                        # nodes.push each
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
                      _nodes = {}
                      _links.forEach (link) ->
                        link.source = _nodes[link.source] or (_nodes[link.source] = name: link.source, value: 0, group: 0)
                        link.target = _nodes[link.target] or (_nodes[link.target] = {name: link.target, group: link.group, lat: link.lat, long: link.long, value: 1})
                        return
                      d3.values((_nodes)).forEach (sourceNode) =>
                        _links.forEach (link) => 
                          if link.source.name == sourceNode.name and link.target.name != sourceNode.name
                            link.target.value += 1
                          return
                        return
                      t_nodes = _nodes
                      t_links = _links
                      # @force.stop()
                      @width = @el.clientWidth
                      @height = $('#bio-region').innerHeight() - $('#header').innerHeight() - $('#statelist').innerHeight()
                      padding = .5
                      color = @color = d3.scale.category10()
                      tnodes = @force.nodes(d3.values(t_nodes))
                      tlinks = @force.links()
                      # enter with the data
                      console.log "@_links", t_links
                      link = @svg.selectAll('.link').data(t_links, (d) ->
                        return d._id
                        )
                      # link.enter().insert("line", ".node").attr("class", "link").style("stroke","lightgray").style("stroke-width", (d, i) -> 
                      #     return Math.sqrt(d.target.value)
                      #   ).style("opacity", 0.4)
                      link.exit().remove()        
                      
                      console.log "node in orf ri", node
                      node = @vis.selectAll('g.node'
                      ).data(d3.values(t_nodes), (d) ->
                        d.name
                      )
                      # nodeEnter = node.enter().append('g').attr('class', 'node').attr("x", 14).attr("dy", "1.35em").call(@force.drag)
                      # nodeEnter.append('circle').property("id", (d, i) => "node-#{i}").attr('r', (d) ->
                      #   if d.group == 2
                      #     return Math.sqrt(d.value) * 2
                      #   else
                      #     return 4
                      # ).attr('x', '-1px').attr('y', '10px').attr('width', '4px').attr('height', '4px'
                      # ).style("stroke", "none"
                      # ).style("opacity", 0.6).style('fill', (d) =>
                      #   return @color(d.group)
                      # ).on('mouseover', (d, i) ->

                      #   return
                      # ).on('mouseout', (d,i) ->
                      #   return
                      # ).on('touchstart', (d, i) ->
                      #   return
                      # ).on('touchend', (d,i) ->
                      #   return
                      # ).call(@force.drag                          )
                      node.exit().remove()
                      node.transition().duration(750).delay((d, i) ->
                        i * 5
                      )          
                      tick = (e) ->
                        link.attr('x1', (d) ->
                          d.source.x
                        ).attr('y1', (d) ->
                          d.source.y
                        ).attr('x2', (d) ->
                          d.target.x
                        ).attr 'y2', (d) ->
                          d.target.y
                        node.attr('transform', (d) ->
                            x = d.x 
                            y = d.y
                            'translate(' + x + ',' + y + ')'
                        )
                        return
                      # @force.on('tick', tick).start()
                      optArray = []
                      j = 0
                      while j < d3.values(t_nodes) - 1
                        optArray.push d3.values(t_nodes)[j].name
                        j++
                      optArray = optArray.sort()
                      toggle = 0
                      linkedByIndex = {}
                      j = 0
                      while j < d3.values(t_nodes).length
                        linkedByIndex[j + ',' + j] = 1
                        j++
                      t_links.forEach (d) ->
                        linkedByIndex[d.source.index + ',' + d.target.index] = 1
                        return
                      node.append('text').style("font-family", "Gill Sans").attr('fill', (d) ->
                        return d3.lab(color(d.group)).darker(2)
                      ).attr("opacity", 0.3).attr('x', 14).attr('dy', '.35em').text (d) ->
                        d.name
                      # @draw(t_nodes, t_links)

      draw: (t_nodes, t_links)->
         # make the links and nodes
        console.log "collection", @collection
        @width = @el.clientWidth
        @height = $('#bio-region').innerHeight() - $('#header').innerHeight() - $('#statelist').innerHeight()
        padding = .5
        color = @color = d3.scale.category10()
        # make the layout structure
        @svg = @vis = d3.select('#organization-region').append('svg:svg').attr('width', @width).attr('height', @height)
        @force = d3.layout.force(
        ).gravity(.6
        ).linkDistance(175
        ).charge(-450
        ).linkStrength(0.5
        ).friction(0.8
        ).size([
          @width
          @height
        ]).on("tick", tick)
        console.log "link and source", t_links, t_nodes
        # use the layout to generate the nodes
        tnodes = @force.nodes(d3.values(t_nodes))
        tlinks = @force.links()
        # enter with the data
        console.log "@_links", t_links
        link = @svg.selectAll('.link').data(t_links, (d) ->
          return d._id
          )
        link.enter().insert("line", ".node").attr("class", "link").style("stroke","lightgray").style("stroke-width", (d, i) -> 
            return Math.sqrt(d.target.value)
          ).style("opacity", 0.4)
        link.exit().remove()        
        
        console.log "node in orf ri", node
        node = @vis.selectAll('g.node'
        ).data(d3.values(t_nodes), (d) ->
          d.name
        )
        nodeEnter = node.enter().append('g').attr('class', 'node').attr("x", 14).attr("dy", "1.35em").call(@force.drag)
        nodeEnter.append('circle').property("id", (d, i) => "node-#{i}").attr('r', (d) ->
          if d.group == 2
            return Math.sqrt(d.value) * 2
          else
            return 4
        ).attr('x', '-1px').attr('y', '10px').attr('width', '4px').attr('height', '4px'
        ).style("stroke", "none"
        ).style("opacity", 0.6).style('fill', (d) =>
          return @color(d.group)
        ).on('mouseover', (d, i) ->

          return
        ).on('mouseout', (d,i) ->
          return
        ).on('touchstart', (d, i) ->
          return
        ).on('touchend', (d,i) ->
          return
        ).call(@force.drag                          )
        node.exit().remove()
        node.transition().duration(750).delay((d, i) ->
          i * 5
        )                       
        tick = (e) ->
          link.attr('x1', (d) ->
            d.source.x
          ).attr('y1', (d) ->
            d.source.y
          ).attr('x2', (d) ->
            d.target.x
          ).attr 'y2', (d) ->
            d.target.y
          node.attr('transform', (d) ->
              x = d.x 
              y = d.y
              'translate(' + x + ',' + y + ')'
          )
          return
        @force.on('tick', tick).start()
        optArray = []
        j = 0
        while j < d3.values(t_nodes) - 1
          optArray.push d3.values(t_nodes)[j].name
          j++
        optArray = optArray.sort()
        toggle = 0
        linkedByIndex = {}
        j = 0
        while j < d3.values(t_nodes).length
          linkedByIndex[j + ',' + j] = 1
          j++
        t_links.forEach (d) ->
          linkedByIndex[d.source.index + ',' + d.target.index] = 1
          return
        node.append('text').style("font-family", "Gill Sans").attr('fill', (d) ->
          return d3.lab(color(d.group)).darker(2)
        ).attr("opacity", 0.3).attr('x', 14).attr('dy', '.35em').text (d) ->
          d.name
        node.on('click', (d, i) ->
          neighboring = (a, b) ->
            linkedByIndex[a.index + ',' + b.index]
          if toggle == 0
            # App.OrgApp.Show.Controller.highlightNodesBy(d)
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
            node.selectAll("circle").transition(100).style 'opacity', 0.6
            link.transition(100).style 'opacity', 1
            node.selectAll("text").transition(100).style('opacity',  0.3
            ).style('font-size', 14
            )
            App.OrgApp.Show.Controller.resetHighlightNodesBy(d)
            toggle = 0
          return
        )
        # App.OrgApp.Show.Controller._links = t_links
        # App.OrgApp.Show.Controller._nodes = t_nodes
        # App.OrgApp.Show.Controller.vis = vis
        searchNode = () ->
          node = @evis.selectAll('g.node')
          if selectedVal == 'none'
            node.style('stroke', 'white').style 'stroke-width', '1'
          else
            selected = node.filter((d, i) ->
              d.name != selectedVal
            )
            selected.style 'opacity', '0'
            link = @svg.selectAll('.link')
            link.style 'opacity', '0'
            d3.selectAll('.node, .link').transition().duration(3000).style 'opacity', 1
          return
    )
  App.OrgApp.View