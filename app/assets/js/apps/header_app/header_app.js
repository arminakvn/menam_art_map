(function() {
  define(["js/app"], function(App) {
    App.module("HeaderApp", function(HeaderApp, App, Backbone, Marionette, $, _) {
      var API;
      this.startWithParent = true;
      App.Router = Marionette.AppRouter.extend({
        appRoutes: {
          header: "showHeader"
        }
      });
      API = {
        showHeader: function() {
          return require(["js/apps/header_app/show/show_controller"], function() {
            return App.HeaderApp.Show.Controller.showHeader();
          });
        }
      };
      return App.addInitializer(function() {
        new App.Router({
          controller: API
        });
        return API.showHeader();
      });
    });
    return App.HeaderApp;
  });

}).call(this);
