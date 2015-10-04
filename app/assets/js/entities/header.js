(function() {
  define(["js/app"], function(App) {
    App.module("Entities", function(Entities, App, Backbone, Marionette, $, _) {
      var API, initializeHeader;
      Entities.Header = Backbone.Model.extend({
        defaults: {
          title: ""
        }
      });
      Entities.HeaderCollection = Backbone.Collection.extend({
        model: Entities.Header
      });
      initializeHeader = new Entities.Header({
        title: ""
      });
      API = {
        getHeaderEntity: function() {
          var defer;
          defer = $.Deferred();
          defer.resolve(initializeHeader);
          return defer.promise();
        },
        getHeaders: function() {
          return new Entities.HeaderCollection([
            {
              name: "location"
            }, {
              name: "person"
            }, {
              name: "organization"
            }
          ]);
        }
      };
      App.reqres.setHandler("header", function() {
        return API.getHeaderEntity();
      });
      return App.reqres.setHandler("header:entities", function() {
        return API.getHeaders();
      });
    });
  });

}).call(this);
