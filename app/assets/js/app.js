(function() {
  define(["marionette", "spin"], function(Marionette, Spinner) {
    var App;
    App = new Marionette.Application();
    App.vent = new Backbone.Wreqr.EventAggregator();
    App.addRegions({
      footerRegion: "#footer-region",
      headerRegion: "#header-region",
      biosRegion: "#bios-region",
      bioRegion: "#bio-region",
      mainRegion: "#main-region",
      navRegion: "#navigation-region"
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
      App.state = {
        "current": 0
      };
      App.opts = {
        lines: 9,
        length: 0,
        width: 23,
        radius: 60,
        scale: 0.5,
        corners: 1,
        color: '#E1E0E0',
        opacity: 0.25,
        rotate: 30,
        direction: 1,
        speed: 0.7,
        trail: 66,
        fps: 40,
        zIndex: 2e9,
        className: 'spinner',
        top: '50%',
        left: '50%',
        shadow: false,
        hwaccel: true,
        position: 'absolute'
      };
      return require(["js/entities/person_link"], (function(_this) {
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
    });
    App.on("initialize:after", function() {
      $.ajax('/distLocs', {
        type: 'GET',
        dataType: 'json',
        error: function(jqXHR, textStatus, errorThrown) {},
        success: function(data, textStatus, jqXHR) {
          App.list = data;
        }
      });
      return require(["js/apps/header_app/header_app", "js/apps/bio_app/bio_app", "js/apps/main_app/main_app", "js/apps/map_app/map_app", "js/apps/footer_app/footer_app", "js/apps/person_app/person_app", "js/apps/org_app/org_app", "js/apps/nav_app/nav_app"], function() {
        console.log("Marionette Application Started");
        if (Backbone.history) {
          Backbone.history.start();
          App.Entities = Backbone.Collections || {};
          App.Entity = Backbone.Models || {};
          if (App.getCurrentRoute() === "") {
            return App.navigate("/", {
              trigger: true
            });
          }
        }
      });
    });
    App.vent.on("spinnerLoading", function(target) {
      console.log("spin", this);
      console.log("spinnerLoading");
      return App.spinner = new Spinner(App.opts).spin(target);
    });
    App.vent.on("spinnerLoaded", function() {
      return App.spinner.stop();
    });
    App.vent.on("personFired", function() {
      return App.navigate("/person", {
        trgigger: true
      });
    });
    App.vent.on("locationFired", function(l) {
      return App.navigate("/location/" + l, {
        trgigger: true
      });
    });
    App.vent.on("organizationFired", function(s) {
      return App.navigate("/organization/" + s, {
        trgigger: true
      });
    });
    App.vent.on("locationsFired", function(l) {
      return App.navigate("/" + l, {
        trgigger: true
      });
    });
    App.vent.on("showBioFired", function(b) {
      return App.navigate("/show");
    });
    App.vent.on("mainFired", function() {
      return App.navigate("/", {
        trigger: true
      });
    });
    return App;
  });

}).call(this);
