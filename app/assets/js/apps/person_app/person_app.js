(function() {
  define(["js/app"], function(App) {
    App.module("PersonApp", function(PersonApp, App, Backbone, Marionette, $, _) {
      var API;
      this.startWithParent = true;
      console.log(App);
      App.Router = Marionette.AppRouter.extend({
        appRoutes: {
          "person/": "showPerson"
        }
      });
      API = {
        showPerson: function() {
          return require(["js/apps/person_app/show/show_controller"], function() {
            return App.PersonApp.Show.Controller.showPerson();
          });
        }
      };
      return App.addInitializer(function() {
        return new App.Router({
          controller: API
        });
      });
    });
    return App.PersonApp;
  });

}).call(this);
