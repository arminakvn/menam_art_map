(function() {
  define(["js/app"], function(App) {
    App.module("Entities", function(Entities, App, Backbone, Marionette, $, _) {
      var API, initializeNavigation;
      Entity.Navigation = Backbone.Model.extend({
        defaults: {
          state_list: "All",
          state_location: "All",
          state_bio: "organization"
        }
      });
      Entities.NavigationCollection = Backbone.Collection.extend({
        model: Entity.Navigation
      });
      initializeNavigation = new Entity.Navigation({
        state_list: "All",
        state_location: "All",
        state_bio: "organization"
      });
      API = {
        getNavigationEntity: function() {
          var defer;
          defer = $.Deferred();
          defer.resolve(initializeNavigation);
          return defer.promise();
        },
        getNavigation: function() {
          return new Entities.NavigationCollection([
            {
              state_list: "All"
            }, {
              state_location: "All"
            }, {
              state_bio: "organization"
            }
          ]);
        }
      };
      App.reqres.setHandler("navigation", function() {
        console.log("inside navigation");
        return API.getNavigationEntity();
      });
      return App.reqres.setHandler("navigation:entities", function() {
        return API.getNavigation();
      });
    });
  });

}).call(this);
