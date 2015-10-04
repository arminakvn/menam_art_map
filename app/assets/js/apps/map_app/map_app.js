(function() {
  define(["js/app"], function(App) {
    App.module("MapApp", function(MapApp, App, Backbone, Marionette, $, _) {
      var API;
      this.startWithParent = true;
      App.commands.setHandler('showLocation', function() {
        API.showLocation();
      });
      App.commands.setHandler('highlightNode', function(sourceNode) {
        API.highlightNode(sourceNode);
      });
      App.commands.setHandler('showLocationByName', function(name) {
        API.showLocationByExistingCollection();
        App.MapApp.Show.Controller.showView.collection.on("sync", function() {
          return API.highlightNode(name);
        });
      });
      App.commands.setHandler('showLocationGroup', function(locationGroup) {
        API.showLocation();
      });
      App.Router = Marionette.AppRouter.extend({
        appRoutes: {
          "location/": "showLocation",
          "location/:locationGroup": "showLocation"
        }
      });
      API = {
        showLocation: function(sourceNode) {
          return require(["js/apps/map_app/show/show_controller"], function() {
            App.MapApp.Show.Controller.showLocation();
            return console.log("inside API");
          });
        },
        highlightNode: function(sourceNode) {
          return require(["js/apps/map_app/show/show_controller"], function() {
            return App.MapApp.Show.Controller.highlightNodesBy(sourceNode);
          });
        },
        showLocationByExistingCollection: function() {
          return require(["js/apps/map_app/show/show_controller"], function() {
            return App.MapApp.Show.Controller.showLocationByExistingCollection();
          });
        },
        showLocationByGroup: function(locationGroup) {
          return require(["js/apps/map_app/show/show_controller"], function() {
            return App.MapApp.Show.Controller.showLocationByGroup(locationGroup);
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
