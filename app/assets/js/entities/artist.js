(function() {
  define(["js/app"], function(App) {
    App.module("Entities", function(Entities, App, Backbone, Marionette, $, _) {
      var API, initializeArtist;
      Entities.ArtistCollection = Backbone.Collection.extend();
      Entities.Artist = Backbone.Model.extend();
      initializeArtist = new Entities.Artist();
      API = {
        getArtistEntity: function() {
          var defer;
          defer = $.Deferred();
          defer.resolve(initializeArtist);
          return defer.promise();
        },
        setArtist: function(artists) {
          return App.ArtistCollection = new Entities.ArtistCollection(artists);
        }
      };
      App.reqres.setHandler("artist", function() {
        return API.getArtistEntity();
      });
      return App.reqres.setHandler("set:artist", function(artists) {
        return API.setArtist(artists);
      });
    });
  });

}).call(this);
