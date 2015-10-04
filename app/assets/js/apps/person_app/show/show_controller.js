(function() {
  define(["js/app", "js/apps/person_app/show/show_view"], function(App, View) {
    App.Entities.PersonNode = Backbone.Model.extend();
    App.Entities.PersonNodeCollection = Backbone.Collection.extend({
      initialize: function() {
        this.on('request', function() {
          console.log("loading");
        });
        this.on('sync', function() {
          console.log("loaded");
        });
      },
      url: function() {
        return "/nodes";
      },
      parse: function(response) {
        var data;
        data = _.map(response, (function(_this) {
          return function(key, value) {
            return {
              "name": key
            };
          };
        })(this));
        return data;
      }
    });
    App.module("PersonApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      return Show.Controller = {
        showPerson: function() {
          var artistNodes;
          artistNodes = new App.Entities.PersonNodeCollection;
          artistNodes.fetch({
            'success': (function(_this) {
              return function(response) {
                return console.log('artistNodes response', response);
              };
            })(this)
          });
          if (this.showView === void 0) {
            this.showView = new View.ShowView({
              collection: artistNodes
            });
          }
          return App.mainRegion.show(this.showView);
        }
      };
    });
    return App.PersonApp.Show.Controller;
  });

}).call(this);
