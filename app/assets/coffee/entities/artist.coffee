define ["js/app"], (App) ->
  App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
    Entities.ArtistCollection = Backbone.Collection.extend(
    )
    Entities.Artist = Backbone.Model.extend(
    )
    initializeArtist = new Entities.Artist(
    )

    API =
      getArtistEntity: ->
        defer = $.Deferred()
        defer.resolve initializeArtist
        defer.promise()

      setArtist: (artists) ->
        App.ArtistCollection = new Entities.ArtistCollection artists


    App.reqres.setHandler "artist", ->
      API.getArtistEntity()

    App.reqres.setHandler "set:artist", (artists) ->
      API.setArtist artists
  return