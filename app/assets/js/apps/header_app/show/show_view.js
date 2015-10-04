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
          "click #organization": "organizationFired",
          "click #biotraj": "biotrajFired",
          "click #main": "mainFired",
          "click #menam-icon": "showModal"
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
        onShow: function() {
          $('input[name="my-checkbox"]').bootstrapSwitch('state', false, true);
          $('input[name="my-checkbox"]').bootstrapSwitch('onText', 'Locations');
          $('input[name="my-checkbox"]').bootstrapSwitch('offText', 'Organizations');
          $('input[name="my-checkbox"]').bootstrapSwitch('size', 'small');
          $('input[name="my-checkbox"]').bootstrapSwitch('onColor', "default");
          $('input[name="my-checkbox"]').bootstrapSwitch('offColor', "default");
          $('input[name="my-checkbox"]').bootstrapSwitch('labelWidth', $("#statebio") * 4);
          return $('input[name="my-checkbox"]').bootstrapSwitch('onSwitchChange', (function(_this) {
            return function(e) {
              var name;
              e.stopPropagation();
              name = App.NavApp.Show.Controller.showView.model.attributes.statelocation.replace("All locations > ", "");
              if ($('input[name="my-checkbox"]').bootstrapSwitch('state') === true) {
                App.execute("showLocationByName", name);
                return App.navigate("#/location/" + name, {
                  trgigger: true
                });
              } else if ((App.getCurrentRoute() === 'location/') && ($('input[name="my-checkbox"]').bootstrapSwitch('state') === false)) {
                return App.navigate("#/organization/" + name, {
                  trgigger: true
                });
              } else if ($('input[name="my-checkbox"]').bootstrapSwitch('state') === false) {
                name = App.getCurrentRoute().replace("organization/", "");
                return App.execute("showLocationByName", name);
              }
            };
          })(this));
        }
      });
    });
    return App.HeaderApp.View;
  });

}).call(this);
