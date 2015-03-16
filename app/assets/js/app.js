(function() {
  define(["marionette"], function(Marionette) {
    var App;
    App = new Marionette.Application();
    App.vent = new Backbone.Wreqr.EventAggregator();
    App.addRegions({
      footerRegion: "#footer-region",
      headerRegion: "#header-region",
      biosRegion: "#bios-region",
      mainRegion: "#main-region"
    });
    App.navigate = function(route, options) {
      if (options == null) {
        options = {};
      }
      if (route.charAt(0) === "/") {
        route = "#" + route;
      }
      return Backbone.history.navigate(route, options);
    };
    App.getCurrentRoute = function() {
      return Backbone.history.fragment;
    };
    App.on("initialize:before", function() {
      require(["js/entities/artist"], (function(_this) {
        return function() {
          return $.ajax('/artistsbygroup/2', {
            type: 'GET',
            dataType: 'json',
            error: function(jqXHR, textStatus, errorThrown) {},
            success: function(data, textStatus, jqXHR) {
              return App.request("set:artist", data);
            }
          });
        };
      })(this));
      require(["js/entities/person_link"], (function(_this) {
        return function() {
          return $.ajax('/links', {
            type: 'GET',
            dataType: 'json',
            error: function(jqXHR, textStatus, errorThrown) {},
            success: function(data, textStatus, jqXHR) {
              return App.request("set:personLink", data);
            }
          });
        };
      })(this));
      return require(["js/entities/person_node"], (function(_this) {
        return function() {
          return $.ajax('/nodes', {
            type: 'GET',
            dataType: 'json',
            error: function(jqXHR, textStatus, errorThrown) {},
            success: function(data, textStatus, jqXHR) {
              return App.request("set:personNode", data);
            }
          });
        };
      })(this));
    });
    App.on("initialize:after", function() {
      return require(["js/apps/header_app/header_app", "js/apps/main_app/main_app", "js/apps/map_app/map_app", "js/apps/footer_app/footer_app", "js/apps/person_app/person_app", "js/apps/org_app/org_app"], function() {
        console.log("Marionette Application Started");
        if (Backbone.history) {
          Backbone.history.start();
          if (App.getCurrentRoute() === "") {
            return App.navigate("/", {
              trigger: true
            });
          }
        }
      });
    });
    App.vent.on("personFired", function() {
      return App.navigate("/person", {
        trgigger: true
      });
    });
    App.vent.on("locationFired", function() {
      return App.navigate("/location", {
        trgigger: true
      });
    });
    App.vent.on("organizationFired", function() {
      return App.navigate("/organization", {
        trgigger: true
      });
    });
    return App;
  });

}).call(this);
