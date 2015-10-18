(function() {
  define(["js/app"], function(App) {
    App.module("BioApp", function(BioApp, App, Backbone, Marionette, $, _) {
      var API;
      this.startWithParent = true;
      App.commands.setHandler('showBio', function(artist) {
        API.showBio(artist);
      });
      App.commands.setHandler('hideBio', function() {
        API.hideBio();
      });
      App.Router = Marionette.AppRouter.extend({
        appRoutes: {
          "bio/:artist": "showBio"
        }
      });
      API = {
        hideBio: function() {
          return require(["js/apps/bio_app/show/show_controller"], function() {
            return App.BioApp.Show.Controller.hideBio();
          });
        },
        showBio: function(artist) {
          return require(["js/apps/bio_app/show/show_controller"], function() {
            return App.BioApp.Show.Controller.showBio(artist);
          });
        }
      };
      return App.addInitializer(function() {
        return new App.Router({
          controller: API
        });
      });
    });
    return App.BioApp;
  });

}).call(this);
