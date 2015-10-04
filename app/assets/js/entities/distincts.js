(function() {
  define(["js/app"], function(App) {
    App.module("Entities", function(Entities, App, Backbone, Marionette, $, _) {
      var API, initializeDistinctLink;
      Entities.DistinctsCollection = Backbone.Collection.extend();
      Entities.DistinctLink = Backbone.Model.extend();
      initializeDistinctLink = new Entities.DistinctLink();
      API = {
        getDistinctLinkEntity: function() {
          var defer;
          defer = $.Deferred();
          defer.resolve(initializeDistinctLink);
          return defer.promise();
        },
        setDistinctLink: function(distinctLinks) {
          return App.DistinctLinkCollection = new Entities.DistinctsCollection(distinctLinks);
        }
      };
      App.reqres.setHandler("distinctLink", function() {
        return API.getDistinctLinkEntity();
      });
      return App.reqres.setHandler("set:distinctLink", function(distinctLink) {
        return API.setDistinctLink(distinctLink);
      });
    });
  });

}).call(this);
