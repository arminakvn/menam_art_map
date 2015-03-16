(function() {
  define(["js/app"], function(App) {
    App.module("Entities", function(Entities, App, Backbone, Marionette, $, _) {
      var API, initializePersonNode;
      Entities.PersonNodeCollection = Backbone.Collection.extend();
      Entities.PersonNode = Backbone.Model.extend();
      initializePersonNode = new Entities.PersonNode();
      API = {
        getPersonNodeEntity: function() {
          var defer;
          defer = $.Deferred();
          defer.resolve(initializePersonNode);
          return defer.promise();
        },
        setPersonNode: function(personNodes) {
          return App.PersonNodeCollection = new Entities.PersonNodeCollection(personNodes);
        }
      };
      App.reqres.setHandler("personNode", function() {
        return API.getPersonNodeEntity();
      });
      return App.reqres.setHandler("set:personNode", function(personNodes) {
        return API.setPersonNode(personNodes);
      });
    });
  });

}).call(this);
