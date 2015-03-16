(function() {
  define(["js/app"], function(App) {
    App.module("Entities", function(Entities, App, Backbone, Marionette, $, _) {
      var API, initializeArtistSource;
      Entities.ArtistSourceCollection = Backbone.Collection.extend();
      Entities.ArtistSource = Backbone.Model.extend();
      initializeArtistSource = new Entities.Artist();
      API = {
        getArtistSourceEntity: function() {
          var defer;
          defer = $.Deferred();
          defer.resolve(initializeArtistSource);
          return defer.promise();
        },
        setArtistSource: function(artists) {
          return App.ArtistSourceCollection = new Entities.ArtistSourceCollection(artists);
        },
        setArtistSourceCollection: function(url) {
          App.ArtistSourceCollection = new Entities.ArtistSourceCollection;
          return App.ArtistSourceCollection.fetch({
            url: url
          });
        }
      };
      App.reqres.setHandler("artistsource", function() {
        return API.getArtistEntity();
      });
      App.reqres.setHandler("set:artistsource", function(artists) {
        return API.setArtistSource(artists);
      });
      return App.reqres.setHandler("set:collection", function(url) {
        return API.setArtistSourceCollection(url);
      });
    });
  });

}).call(this);
