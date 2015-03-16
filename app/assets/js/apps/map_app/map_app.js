(function() {
  define(["js/app"], function(App) {
    App.module("MapApp", function(MapApp, App, Backbone, Marionette, $, _) {
      var API;
      this.startWithParent = true;
      App.commands.setHandler('highlightNode', function(sourceNode) {
        API.highlightNode(sourceNode);
      });
      App.Router = Marionette.AppRouter.extend({
        appRoutes: {
          "location/": "showLocation"
        }
      });
      API = {
        showLocation: function() {
          return require(["js/apps/map_app/show/show_controller"], function() {
            App.MapApp.Show.Controller.showLocation();
            return console.log("inside API");
          });
        },
        highlightNode: function(sourceNode) {
          return require(["js/apps/map_app/show/show_controller"], function() {
            return App.MapApp.Show.Controller.highlightNodesBy(sourceNode);
          });
        }
      };
      return App.addInitializer(function() {
        return new App.Router({
          controller: API
        });
      });
    });
    return App.MapApp;
  });

}).call(this);
