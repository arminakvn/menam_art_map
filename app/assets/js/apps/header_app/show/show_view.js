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
        events: {
          "click #location": "locationFired",
          "click #person": "personFired",
          "click #organization": "organizationFired",
          "click #biotraj": "biotrajFired"
        },
        locationFired: (function(_this) {
          return function(e) {
            return App.vent.trigger("locationFired");
          };
        })(this),
        personFired: (function(_this) {
          return function(e) {
            return App.vent.trigger("personFired");
          };
        })(this),
        organizationFired: (function(_this) {
          return function(e) {
            return App.vent.trigger("organizationFired");
          };
        })(this),
        biotrajFired: (function(_this) {
          return function(e) {};
        })(this)
      });
    });
    return App.HeaderApp.View;
  });

}).call(this);
