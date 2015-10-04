(function() {
  define(["js/app"], function(App) {
    App.module("Entities", function(Entities, App, Backbone, Marionette, $, _) {
      var API;
      Entities.ArtistSourceCollection = Backbone.Collection.extend({
        model: Entities.ArtistSource,
        initialize: function() {
          this.on('request', function() {
            console.log("loading");
          });
          this.on('sync', function() {
            console.log("loaded");
          });
        },
        url: function() {
          var full_url;
          return full_url = '/artistssource';
        },
        parse: function(response) {
          console.log("response", response);
          return response.data;
        }
      });
      Entities.ArtistSource = Backbone.Model.extend();
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
        setArtistSourceCollection: function() {
          return App.ArtistSourceCollection = new Entities.ArtistSourceCollection;
        },
        getArtistSourceCollection: function() {
          return App.ArtistSourceCollection;
        },
        getArtistSourceCollectionBy: function(group) {
          var filterdModel;
          filterdModel = App.ArtistSourceCollection.where({
            target: group
          });
          console.log("in the Entities", "group:", group, "filterdModel:", filterdModel, "App.ArtistSourceCollection", App.ArtistSourceCollection);
          return filterdModel;
        },
        updateArtistSource: function(artists) {
          App.ArtistSourceCollection = new Entities.ArtistSourceCollection;
          return App.ArtistSourceCollection.fetch({
            url: artists
          });
        }
      };
      App.reqres.setHandler("artistsourceCollection", function() {
        return API.getArtistSourceCollection();
      });
      App.reqres.setHandler("set:artistsource", function(artists) {
        return API.setArtistSource(artists);
      });
      App.reqres.setHandler("update:artistsource", function(artists) {
        return API.updateArtistSource(artists);
      });
      App.reqres.setHandler("set:collection", function() {
        return API.setArtistSourceCollection;
      });
      return App.reqres.setHandler("artistsourceCollectionBy", function(group) {
        return API.getArtistSourceCollectionBy(group);
      });
    });
  });

}).call(this);
