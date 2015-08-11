define ["js/app"], (App) ->
  App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
    Entities.ArtistSourceCollection = Backbone.Collection.extend(
      model: Entities.ArtistSource
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
      url: -> 
        full_url = '/artistssource'
        # if @queryString != null
        #   full_url = full_url + '&' + @queryString
        # full_url

      parse: (response) ->
        console.log "response", response

        response.data

    )
    Entities.ArtistSource = Backbone.Model.extend(

    )

    API =
      getArtistSourceEntity: ->
        defer = $.Deferred()
        defer.resolve initializeArtistSource
        defer.promise()

      setArtistSource: (artists) ->
        App.ArtistSourceCollection = new Entities.ArtistSourceCollection artists

      setArtistSourceCollection: ()->
          App.ArtistSourceCollection = new Entities.ArtistSourceCollection
          # App.ArtistSourceCollection.fetch 'success': (response) ->
          #   console.log "fetch is done", response
          #   return
          # artists_source_collection
          # artists_source_collection.fetch 'success': (response) ->
          #   response
          # artists_source_collection.fetch 'success': (response) ->
          #   console.log "before returning response", response
          #   response
        # console.log "url or artistsource", url
        # $.ajax url,
        #       type: 'GET'
        #       dataType: 'json'
        #       error: (jqXHR, textStatus, errorThrown) ->
        #       success: (data, textStatus, jqXHR) =>
        #         console.log "data", data
                
        #         App.ArtistSourceCollection = new Entities.ArtistSourceCollection data
        #         return App.ArtistSourceCollection
        
        # App.ArtistSourceCollection.fetch url: url
        # defer = $.Deferred()
        # defer.resolve App.ArtistSourceCollection
        # defer.promise()
        # console.log 'App.ArtistSourceCollection', App.ArtistSourceCollection


      getArtistSourceCollection: ->
        # App.ArtistSourceCollection.save()
        return App.ArtistSourceCollection

      getArtistSourceCollectionBy: (group) -> 
        filterdModel = App.ArtistSourceCollection.where({target: group})
        console.log "in the Entities", "group:", group, "filterdModel:", filterdModel, "App.ArtistSourceCollection",App.ArtistSourceCollection
        return filterdModel

      updateArtistSource: (artists) ->
        App.ArtistSourceCollection = new Entities.ArtistSourceCollection
        App.ArtistSourceCollection.fetch url: artists
        # $.when(App.ArtistSourceCollection).done (newArtistSourceCollection) =>
        #   return newArtistSourceCollection.save()
        # App.ArtistSourceCollection.save()





    App.reqres.setHandler "artistsourceCollection", ->
      API.getArtistSourceCollection()

    App.reqres.setHandler "set:artistsource", (artists) ->
      API.setArtistSource artists

    App.reqres.setHandler "update:artistsource", (artists) ->
      API.updateArtistSource artists

    App.reqres.setHandler "set:collection", ->
      API.setArtistSourceCollection

    App.reqres.setHandler "artistsourceCollectionBy", (group) ->
      API.getArtistSourceCollectionBy(group)

  return