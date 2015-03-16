(function() {
  define(["js/app"], function(App) {
    App.module("OrgApp", function(OrgApp, App, Backbone, Marionette, $, _) {
      var API;
      this.startWithParent = true;
      App.Router = Marionette.AppRouter.extend({
        appRoutes: {
          "organization/": "showOrganization"
        }
      });
      API = {
        showOrganization: function() {
          return require(["js/apps/org_app/show/show_controller"], function() {
            return App.OrgApp.Show.Controller.showOrganization();
          });
        }
      };
      return App.addInitializer(function() {
        return new App.Router({
          controller: API
        });
      });
    });
    return App.OrgApp;
  });

}).call(this);
