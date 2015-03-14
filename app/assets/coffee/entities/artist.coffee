define ["js/app"], (App) ->
  App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
    Entities.ArtistCollection = Backbone.Collection.extend(
      # model: Entities.Artist
      # url:'/artists'
    )
    Entities.Artist = Backbone.Model.extend(
      # urlRoot: '/artists'
      # idAttribute: '_id'
      # defaults:
        # name: "artist"
    )
    initializeArtist = new Entities.Artist(
      # title: "Hello artistsnetwork "
      # message: "Everything is working, ...purrfectly"
    )

    API =
      # get feed model by Id
      getArtistEntity: ->
        defer = $.Deferred()
        defer.resolve initializeArtist
        defer.promise()

      setArtist: (artists) ->
        new Entities.ArtistCollection artists


    App.reqres.setHandler "artist", ->
      API.getArtistEntity()

    App.reqres.setHandler "set:artist", (artists) ->
      API.setArtist artists
  return