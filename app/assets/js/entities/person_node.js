(function() {
  define(["js/app"], function(App) {
    App.module("Entities", function(Entities, App, Backbone, Marionette, $, _) {
      var API, initializePersonNode;
      Entities.PersonNode = Backbone.Model.extend();
      Entities.PersonNodeCollection = Backbone.Collection.extend({
        initialize: function() {
          this.on('request', function() {
            console.log("loading");
          });
          this.on('sync', function() {
            console.log("loaded");
          });
        },
        url: function() {
          return "/nodes";
        },
        parse: function(response) {
          var data;
          data = _.map(response, (function(_this) {
            return function(key, value) {
              return {
                "name": key
              };
            };
          })(this));
          return data;
        }
      });
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
