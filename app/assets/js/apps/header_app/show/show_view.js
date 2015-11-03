(function() {
  define(["js/app", "tpl!js/apps/header_app/show/templates/_header.tpl", "tpl!js/apps/header_app/show/templates/_headers.tpl"], function(App, headerTpl, headersTpl) {
    App.module("HeaderApp.View", function(View, App, Backbone, Marionette, $, _) {
      View.HeaderView = Marionette.ItemView.extend({
        template: headerTpl,
        tagName: "li"
      });
      return View.HeadersView = Marionette.CompositeView.extend({
        template: headersTpl,
        itemView: View.HeaderView,
        itemViewContainer: "ul",
        id: "menam-icon",
        events: {
          "click #locations": "organizationFired",
          "click #person": "personFired",
          "click #organizations": "locationFired",
          "mouseover #organizations": "organizationMousover",
          "mouseout #organizations": "organizationMousout",
          "mouseover #locations": "locationMousover",
          "mouseout #locations": "locationMousout",
          "click #biotraj": "biotrajFired",
          "click #main": "mainFired",
          "click #menam-icon": "showModal"
        },
        personFired: (function(_this) {
          return function(e) {};
        })(this),
        locationFired: (function(_this) {
          return function(e) {
            console.log("App.state.current", App.state.current);
            $('#locations').removeClass('navmodeOn');
            $('#locations').addClass('navmodeOff');
            $('#organizations').removeClass('navmodeOff');
            $('#organizations').addClass('navmodeOn');
            return App.state.current = 0;
          };
        })(this),
        organizationFired: (function(_this) {
          return function(e) {
            console.log("App.state.current", App.state.current);
            $('#organizations').removeClass('navmodeOn');
            $('#organizations').addClass('navmodeOff');
            $('#locations').removeClass('navmodeOff');
            $('#locations').addClass('navmodeOn');
            App.state.current = 1;
            return App.navigate("/", {
              trgigger: true
            });
          };
        })(this),
        biotrajFired: (function(_this) {
          return function(e) {};
        })(this),
        mainFired: (function(_this) {
          return function(e) {
            return App.vent.trigger("mainFired");
          };
        })(this),
        showModal: (function(_this) {
          return function(e) {
            console.log("showModal");
            return App.NavApp.Show.Controller.showModal();
          };
        })(this),
        organizationMousover: (function(_this) {
          return function(e) {
            return $(e.target).css('cursor', 'pointer');
          };
        })(this),
        organizationMousoout: (function(_this) {
          return function(e) {
            return $(e.target).css('cursor', 'default');
          };
        })(this),
        locationMousover: (function(_this) {
          return function(e) {
            return $(e.target).css('cursor', 'pointer');
          };
        })(this),
        locationMousoout: (function(_this) {
          return function(e) {
            return $(e.target).css('cursor', 'default');
          };
        })(this),
        onShow: function() {}
      });
    });
    return App.HeaderApp.View;
  });

}).call(this);
