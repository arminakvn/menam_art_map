define ["js/app","tpl!js/apps/map_app/show/templates/show_item_view.tpl", "tpl!js/apps/map_app/show/templates/show_view.tpl"], (App,showItemTpl, showTpl) ->
  App.module "MapApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.ShowItemView = Marionette.ItemView.extend(
      template: showItemTpl
    )
    View.ShowView = Marionette.CompositeView.extend(
      itemView: View.ShowItemView
      template: showTpl
      # itemViewContainer: 'g'
      id:"map"
      tagName:"div"
      onBeforeRender: ->
        @$el.animate({
          opacity: 1
        }, 500)
      onBeforeClose: ->
        @$el.animate({
          opacity: 0
        }, 750)
        
      
       
      onShow: ->
        # require ["js/entities/artist"], =>
          # console.log "@collection", @collection
          # textResponse = $.ajax
          #               url: "/artistsbygroup/1"
          #               success: (result) =>
          #                 result
          # $.when(textResponse).done (artists) =>
            # console.log artists
          #   # artists = artist.responseJSON
          #   # @collection = App.ArtistCollection
            # @$el = $('main-region')
            removeDuplicates = (ar) ->
              if ar.length == 0
                return []  
              res = {}
              res[ar[key]] = ar[key] for key in [0..ar.length-1]
              value for key, value of res
            list = []
            for model in @collection.models
              # console.log "model", model
              try
                list.push model.attributes.target
              catch e
                # ...
            @list = list
            # console.log "@list", @list
            id = 0
            @artistNodes = [] 
            nodes = []
            # console.log "@model", @model
            for artist in @collection.models
              nodes.push artist
              # make a list of artist names when data arrives and keep it
              @artistNodes.push {'name' :artist.attributes.source, 'id': id, 'group': artist.attributes.group}
              id = id + 1
            # using the data to create links and nodes in format
      
            _links = @collection.models
            # console.log "@collection.models", @collection.models
            # sort links by source, then target
            _links.sort (a, b) ->
                if a.attributes.source > b.attributes.source
                  1
                else if a.attributes.source < b.attributes.source
                  -1
                else
                  if a.attributes.target > b.attributes.target
                    return 1
                  if a.attributes.target < b.attributes.target
                    -1
                  else
                    0
            i = 0
            # any links with duplicate source and target get an incremented 'linknum'
            while i < _links.length
              if i != 0 and _links[i].attributes.source == _links[i - 1].attributes.source and _links[i].attributes.target == _links[i - 1].attributes.target
                _links[i].linknum = _links[i - 1].linknum + 1
              else
                _links[i].linknum = 1
              i++
            
            _nodes = {}
            # Compute the distinct nodes from the links.
            @collection.models.forEach (link) ->
              link.attributes.source = _nodes[link.attributes.source] or (_nodes[link.attributes.source] = name: link.attributes.source, value: 1)
              link.attributes.target = _nodes[link.attributes.target] or (_nodes[link.attributes.target] = {name: link.attributes.target, group: link.attributes.group, lat: link.attributes.lat, long: link.attributes.long, value: 1})

            d3.values((_nodes)).forEach (sourceNode) =>
              @collection.models.forEach (link) => 
                if link.attributes.source.name == sourceNode.name and link.attributes.target.name != sourceNode.name
                  link.attributes.target.value += 1
                return
              return  
              return
            # d3.values((_nodes)).forEach (sourceNode) =>
            #   _links.forEach (link) => 
            #     if link.source.name == sourceNode.name and link.target.name != sourceNode.name
            #       link.target.value += 1
            #     return
            #   return
            # for each in d3.values(_nodes)
            #   @collection.add(new App.Entity.LocationNode({'target': each.name}))
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
            # divControl = L.Control.extend(  
            #   initialize: =>
            #     position = "left"
            #     _domEl = L.DomUtil.create('div', "container " + "bioController" + "-info")
            #     # _domEl.innerHTML = "<div></div>"
            #     # L.DomUtil.enableTextSelection(_domEl)  
            #     @_m.getContainer().getElementsByClassName("leaflet-control-container")[0].appendChild(_domEl)
            #     _domObj = $(L.DomUtil.get(_domEl))
            #     _domObj.css('width', $(@_m.getContainer())[0].clientWidth/4)
            #     _domObj.css('height', $(@_m.getContainer())[0].clientHeight/1.1)
            #     _domObj.css('line-height', '22px')
            #     L.DomUtil.setOpacity(L.DomUtil.get(_domEl), 0.0)
            #     L.DomUtil.setPosition(L.DomUtil.get(_domEl), L.point(-$(@_m.getContainer())[0].clientWidth/1.2, 0), disable3D=0)
            #     @position = L.point(-$(@_m.getContainer())[0].clientWidth/1.05, 0)
            #     @fx = new L.PosAnimation()
            #     @fx.run(L.DomUtil.get(_domEl), position, 0.9)
            #     @_bios_domEl = _domEl
            #     @_m.on "click", =>
            #       @fx.run(L.DomUtil.get(_domEl), @position, 0.9)
            #     @_d3BiosEl = d3.select(_domEl)
            # )
            # new divControl()
            # console.log "_links", _links
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
                      opacity: 0.5
                      fillOpacity: 0.5
                      weight: 1
                      className: 'locations-nodes'
                      id: "#{each.name}"
                      clickable: true).setRadius(Math.sqrt(each.value) * 3).bindPopup("<span href='#location/#{each.name}'>#{each.name}</span>")
                  nodeGroup.addLayer(circle)
            nodeGroup.eachLayer (layer) =>
              # @markers = new L.MarkerClusterGroup([],maxZoom: 8, spiderfyOnMaxZoom:true, zoomToBoundsOnClick:true, spiderfyDistanceMultiplier:2)
              # @markers.addTo(@_m)
              layer.on "mouseover", (e) =>
                # console.log "mouseover"
                e.target.openPopup()
              layer.on "mouseout", (e) =>
                # console.log "mouseover"
                e.target.closePopup()
              layer.on "click", (e) =>
                App.MainApp.Show.Controller.updateView layer.options.id
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
            @model = @nodeGroup
            App.MapApp.Show.Controller.nodeGroup = nodeGroup
            App.MapApp.Show.Controller.markers = @markers
            App.MapApp.Show.Controller.popupGroup = @popupGroup
            # console.log "@nodeGroup.getLayers()", @nodeGroup.getLayers()
            # w = $(_m.getContainer())[0].clientWidth#/1.2
            # h = $(_m.getContainer())[0].clientHeight
            # nodes = @artistNodes
            fx = new L.PosAnimation()
        # return

    )
  App.MapApp.View