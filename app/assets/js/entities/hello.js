(function() {
  define(["js/app"], function(App) {
    App.module("Entities", function(Entities, App, Backbone, Marionette, $, _) {
      var API, initializeHello;
      Entities.Show = Backbone.Model.extend({
        defaults: {
          title: "Hello App"
        }
      });
      initializeHello = new Entities.Show({
        title: "Hello artistsnetwork ",
        message: "Everything is working, ...purrfectly"
      });
      API = {
        getShowEntity: function() {
          var defer;
          defer = $.Deferred();
          defer.resolve(initializeHello);
          return defer.promise();
        }
      };
      return App.reqres.setHandler("show", function() {
        return API.getShowEntity();
      });
    });
  });

}).call(this);
