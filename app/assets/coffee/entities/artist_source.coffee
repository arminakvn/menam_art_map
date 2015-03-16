define ["js/app"], (App) ->
  App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
    Entities.ArtistSourceCollection = Backbone.Collection.extend(
    )
    Entities.ArtistSource = Backbone.Model.extend(
    )
    initializeArtistSource = new Entities.Artist(
    )

    API =
      getArtistSourceEntity: ->
        defer = $.Deferred()
        defer.resolve initializeArtistSource
        defer.promise()

      setArtistSource: (artists) ->
        App.ArtistSourceCollection = new Entities.ArtistSourceCollection artists

      setArtistSourceCollection: (url) ->
        App.ArtistSourceCollection = new Entities.ArtistSourceCollection
        App.ArtistSourceCollection.fetch url: url



    App.reqres.setHandler "artistsource", ->
      API.getArtistEntity()

    App.reqres.setHandler "set:artistsource", (artists) ->
      API.setArtistSource artists

    App.reqres.setHandler "set:collection", (url) ->
      API.setArtistSourceCollection url

  return