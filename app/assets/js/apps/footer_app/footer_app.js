(function() {
  define(["js/app"], function(App) {
    App.module("FooterApp", function(FooterApp, App, Backbone, Marionette, $, _) {
      var API;
      this.startWithParent = true;
      App.Router = Marionette.AppRouter.extend({
        appRoutes: {
          footer: "showFooter"
        }
      });
      API = {
        showFooter: function() {
          return require(["js/apps/footer_app/show/show_controller"], function() {
            return App.FooterApp.Show.Controller.showFooter();
          });
        }
      };
      return App.addInitializer(function() {
        new App.Router({
          controller: API
        });
        return API.showFooter();
      });
    });
    return App.FooterApp;
  });

}).call(this);
