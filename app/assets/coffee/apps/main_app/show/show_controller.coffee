define ["js/app", "js/apps/main_app/show/show_view"], (App, View) ->
  App.Entities = Backbone.Collections || {}
  App.Entity = Backbone.Models || {}
  App.Entity.ArtistSource = Backbone.Model.extend(


  )
  App.Entities.ArtistSourceCollection = Backbone.Collection.extend(
    model: App.Entity.ArtistSource
    initialize:  ->
      # @queryString = options.queryString or null
      @on 'request', ->
        # MfiaClient.app.trigger 'loading'
        console.log "loading"
        return
      @on 'sync', ->
        # MfiaClient.app.trigger 'loaded'
        console.log "loaded"
        return
      return
    url: (q)-> 
      console.log "queryString inside url", q
      full_url = '/artistssource'
      if @queryString != undefined
         # full_url = full_url + '&' + @queryString
         new_url = 'sourceByTarget/#{q}'
         full_url = new_url
      console.log "@",@, full_url
      full_url

    parse: (response) ->
      # console.log "response", response
      data = _.map response, (key, value) =>
        # _.map key, (key, value) =>
          # key
        "name": key
      data

      # response.data

  )
  App.module "MainApp.Show", (Show, App, Backbone, Marionette, $, _) ->
    Show.Controller =
      ShowModel: ['Abbas Akhavan']
      updateView: (names) ->
        artistssourceC = new App.Entities.ArtistSourceCollection url: names

        artistssourceC.fetch 'success': (response) =>
        # console.log "@ inside Show.Controller", @
          @showView.children.each (childview) =>
            # console.log "childview", childview
            # console.log "@", @
            @showView.remove(childview)
          
          @showView = new View.ShowViews(collection: artistssourceC)
          App.biosRegion.show @showView

        # @showView.children.each (view) =>
        #   console.log view
        # artistssourceC = new App.Entities.ArtistSourceCollection
        # artistssourceC.fetch 'success': (response) =>
        #   # console.log response
        #   # filterd = artistssourceC.where("name": arg)
        #   @showView = new View.ShowViews(collection: new App.Entities.ArtistSourceCollection(names))
        #   App.biosRegion.show @showView
      
      showView: ->
          
          # $.when(App.request "set:collection").done (collectionF) =>
            # console.log "App.ArtistSourceCollection", App.ArtistSourceCollection
          # console.log "ArtistModel", ArtistModel
            # console.log "before returning response", response
          artistssourceC = new App.Entities.ArtistSourceCollection
          artistssourceC.fetch 'success': (response) =>
            # console.log response
            distinctedSources = artistssourceC.where()
            @showView = new View.ShowViews(collection: artistssourceC)
            App.biosRegion.show @showView
            # console.log "artistssourceC", artistssourceC
          # $.when(artistssourceC).done (res) =>
            # console.log "res", res
          # $.when(ArtistModel).done (response) =>
            # console.log "Model", ArtistModel
            # @showView = new View.ShowView(collection: ArtistModel)
            # App.mainRegion.show @showView
      		# getCollection = App.request "set:collection", 'artistssource'
      		# $.when(getCollection).done (artists) =>
        #     console.log "artists", artists
            

  App.MainApp.Show.Controller

