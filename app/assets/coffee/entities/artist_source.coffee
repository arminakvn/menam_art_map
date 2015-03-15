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



    App.reqres.setHandler "artistsource", ->
      API.getArtistEntity()

    App.reqres.setHandler "set:artistsource", (artists) ->
      API.setArtistSource artists

  return