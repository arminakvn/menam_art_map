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
          "click #location": "locationFired",
          "click #person": "personFired",
          "click #organizations": "organizationFired",
          "mouseover #organizations": "organizationMousover",
          "mouseout #organizations": "organizationMousout",
          "click #biotraj": "biotrajFired",
          "click #main": "mainFired",
          "click #menam-icon": "showModal"
        },
        locationFired: (function(_this) {
          return function(e) {};
        })(this),
        personFired: (function(_this) {
          return function(e) {};
        })(this),
        organizationFired: (function(_this) {
          return function(e) {
            if (App.state.current === 0) {
              $('#organizations').html("");
              $('#organizations').html("Organizations");
              return App.state.current = 1;
            } else {
              $('#organizations').html("");
              $('#organizations').html("Locations");
              App.state.current = 0;
              return App.navigate("/", {
                trgigger: true
              });
            }
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
        onShow: function() {}
      });
    });
    return App.HeaderApp.View;
  });

}).call(this);
