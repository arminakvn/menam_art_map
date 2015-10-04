(function() {
  define(["js/app"], function(App) {
    App.module("NavApp", function(NavApp, App, Backbone, Marionette, $, _) {
      var API;
      this.startWithParent = true;
      App.Router = Marionette.AppRouter.extend({
        appRoutes: {
          navigation: "showNavigation"
        }
      });
      API = {
        showNavigation: function() {
          return require(["js/apps/nav_app/show/show_controller"], function() {
            return App.NavApp.Show.Controller.showNavigation();
          });
        }
      };
      return App.addInitializer(function() {
        new App.Router({
          controller: API
        });
        return API.showNavigation();
      });
    });
    return App.NavApp;
  });

}).call(this);
