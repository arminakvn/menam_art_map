define ["js/app", "tpl!js/apps/map_app/show/templates/show_view.tpl"], (App, showTpl) ->
  App.module "MapApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.ShowView = Marionette.ItemView.extend(
      template: showTpl
      id:"location-region"
      tagName:"div"
      onShow: ->
        # require ["js/entities/artist"], =>
          textResponse = $.ajax
                        url: "/artistsbygroup/1"
                        success: (result) =>
                          result
          $.when(textResponse).done (artists) =>
            # artists = artist.responseJSON
            # @collection = App.ArtistCollection
            # @$el = $('main-region')
            id = 0
            @artistNodes = [] 
            nodes = []

            for artist in artists
              nodes.push artist
              # make a list of artist names when data arrives and keep it
              @artistNodes.push {'name' :artist.source, 'id': id, 'group': artist.group}
              id = id + 1
            # using the data to create links and nodes in format
      
            _links = nodes
            # sort links by source, then target
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
            # any links with duplicate source and target get an incremented 'linknum'
            while i < _links.length
              if i != 0 and _links[i].source == _links[i - 1].source and _links[i].target == _links[i - 1].target
                _links[i].linknum = _links[i - 1].linknum + 1
              else
                _links[i].linknum = 1
              i++
            
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

            # $("#main-region").append("<div id='map'></div>")
            L.mapbox.accessToken = "pk.eyJ1IjoiYXJtaW5hdm4iLCJhIjoiSTFteE9EOCJ9.iDzgmNaITa0-q-H_jw1lJw"
            @_m = L.mapbox.map("map", "arminavn.jhehgjan
              ",
                zoomAnimation: true
                dragAnimation: true
                attributionControl: false
                zoomAnimationThreshold: 10
                inertiaDeceleration: 4000
                animate: true
                duration: 1.75
                zoomControl: false
                doubleClickZoom: false
                infoControl: false
                easeLinearity: 0.1
                maxZoom: 5
                )
            @_m.setView([
                      42.34
                      0.12
                    ], 3)
            @_m.boxZoom.enable()
            @_m.scrollWheelZoom.disable()
            @_m.on "click", =>
              @nodeGroup.eachLayer (layer) =>
                layer.setStyle
                  opacity: 0.1
                  fillOpacity: 0.1
                  clickable: false
              @_m.setView([
                      42.34
                      0.12
                    ], 3)
              return
            ###
            making the bios controller
            ###
            divControl = L.Control.extend(  
              initialize: =>
                position = "left"
                _domEl = L.DomUtil.create('div', "container " + "bioController" + "-info")
                L.DomUtil.enableTextSelection(_domEl)  
                @_m.getContainer().getElementsByClassName("leaflet-control-container")[0].appendChild(_domEl)
                _domObj = $(L.DomUtil.get(_domEl))
                _domObj.css('width', $(@_m.getContainer())[0].clientWidth/4)
                _domObj.css('height', $(@_m.getContainer())[0].clientHeight/1.3)
                _domObj.css('background-color', 'white')
                _domObj.css("font-family", "Gill Sans")
                _domObj.css("font-size", "24")
                _domObj.css('overflow', 'auto')
                _domObj.css('line-height', '28px')
                L.DomUtil.setOpacity(L.DomUtil.get(_domEl), 0.0)
                L.DomUtil.setPosition(L.DomUtil.get(_domEl), L.point(-$(@_m.getContainer())[0].clientWidth/1.2, 0), disable3D=0)
                @position = L.point(-$(@_m.getContainer())[0].clientWidth/1.05, 0)
                @fx = new L.PosAnimation()
                @fx.run(L.DomUtil.get(_domEl), position, 0.9)
                @_bios_domEl = _domEl
                @_m.on "click", =>
                  @fx.run(L.DomUtil.get(_domEl), @position, 0.9)
                @_d3BiosEl = d3.select(_domEl)
            )
            new divControl()

            @_nodes = _nodes
            @_links = _links
            App.MapApp.Show.Controller._links = _links
            eachcnt = 0
            nodeGroup = L.layerGroup([])
            @color = d3.scale.category10()
            color = @color
            @popupGroup = L.layerGroup([])
            @popupGroup.addTo(@_m)
            for each in d3.values(_nodes)
              eachcnt = 1 + eachcnt
              try
                if each.group == 1 and each.lat
                  ltlong = new L.LatLng(+each.lat, +each.long)
                  circle = new L.CircleMarker(ltlong,
                      color: "gray"
                      opacity: 0.5
                      fillOpacity: 0.5
                      weight: 1
                      className: "#{eachcnt-1}"
                      id: "#{each.name}"
                      clickable: true).setRadius(Math.sqrt(each.value) * 1).bindPopup("<p style='font-size:12px; line-height:10px; font-style:bold;'><a href='#location/#{each.name}'>#{each.name}</p><p style='font-size:12px; font-style:italic; line-height:10px;'>#{each.value - 1} artists connected to this location</p>")
                  nodeGroup.addLayer(circle)
            # nodeGroup.eachLayer (layer) =>
            #   @markers = new L.MarkerClusterGroup([],maxZoom: 8, spiderfyOnMaxZoom:true, zoomToBoundsOnClick:true, spiderfyDistanceMultiplier:2)
            #   @markers.addTo(@_m)
            #   layer.on "mouseover", (e) =>
            #     # console.log "mouseover"
            #     # e.target.openPopup()
            #   layer.on "click", (e) =>
            #     @markers.clearLayers()
            #     textResponse = $.ajax
            #         url: "/artstsby/#{layer.options.id}"
            #         success: (nodes) =>
            #           currentzoom = @_m.getZoom()
            #           # @_m.remove(markers)
            #           marker = new L.CircleMarker([])
            #           nodes.forEach (artist) =>
            #             artistNode = new L.LatLng(+artist.lat, +artist.long)
            #             marker = new L.CircleMarker(artistNode,
            #               color: d3.lab("gray").darker(-2)
            #               opacity: 0.5
            #               fillOpacity: 0.5
            #               weight: 1
            #               # id: "#{artist.name}"
            #               clickable: true).setRadius(7).bindPopup("<p>#{artist.source}</p>")
            #             @markers.addLayer(marker)

            #   return
            nodeGroup.addTo(@_m)
            @nodeGroup = nodeGroup
            App.MapApp.Show.Controller.nodeGroup = nodeGroup
            App.MapApp.Show.Controller.markers = @markers
            App.MapApp.Show.Controller.popupGroup = @popupGroup
            # w = $(_m.getContainer())[0].clientWidth#/1.2
            # h = $(_m.getContainer())[0].clientHeight
            # nodes = @artistNodes
            fx = new L.PosAnimation()
        # return

    )
  App.MapApp.View