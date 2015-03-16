(function() {
  define(["js/app"], function(App) {
    App.module("MainApp", function(MainApp, App, Backbone, Marionette, $, _) {
      var API, ifControl, inWidth, myData;
      this.startWithParent = false;
      App.Router = Marionette.AppRouter.extend({
        appRoutes: {
          main: "showView"
        }
      });
      API = {
        showView: function() {
          return require(["js/apps/main_app/show/show_controller"], function() {
            return App.MainApp.Show.Controller.showView();
          });
        }
      };
      App.addInitializer(function() {
        new App.Router({
          controller: API
        });
        return API.showView();
      });
      this === MainApp;
      myData = 'this is private data';
      ifControl = false;
      return inWidth = 60;
    });
    return App.MainApp;
  });

}).call(this);
