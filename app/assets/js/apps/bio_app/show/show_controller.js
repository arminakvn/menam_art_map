(function() {
  define(["js/app", "js/apps/bio_app/show/show_view", "tpl!js/apps/bio_app/show/templates/bio_view.tpl", "tpl!js/apps/bio_app/show/templates/bios_view.tpl"], function(App, View, BioViewTpl, BiosViewTpl) {
    App.Entity.BioElement = Backbone.Model.extend();
    App.Entities.BioElementTextCollection = Backbone.Collection.extend({
      model: App.Entity.BioElement,
      initialize: function() {
        this.on('request', function() {
          var target;
          target = document.getElementById('bio-region');
          App.vent.trigger("spinnerLoading", target);
          console.log("loading");
        });
        this.on('sync', function() {
          App.vent.trigger("spinnerLoaded");
          console.log("loaded");
        });
      },
      url: function() {
        var url;
        url = "/biosby/" + App.BioApp.Show.Controller.url;
        return url;
      },
      parse: function(response) {
        var data, splirR;
        splirR = response[0].__text.split(' ');
        data = _.map(splirR, (function(_this) {
          return function(key, value) {
            return {
              'name': key
            };
          };
        })(this));
        return data;
      }
    });
    App.module("BioApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      return Show.Controller = {
        listLevelOne: function(sourceNode) {
          var updateCollection;
          updateCollection = $.ajax('/distLocbysourceartist/' + sourceNode.replace(/^\s+|\s+$/g, "", {
            type: 'GET',
            dataType: 'json',
            error: function(jqXHR, textStatus, errorThrown) {},
            success: (function(_this) {
              return function(data, textStatus, jqXHR) {
                var ret;
                return ret = _.map(data, function(key, value) {
                  return {
                    "target": key.target
                  };
                });
              };
            })(this)
          }));
          $.when(updateCollection).done((function(_this) {
            return function(respnd) {
              return respnd;
            };
          })(this));
          return updateCollection;
        },
        hideBio: (function(_this) {
          return function() {};
        })(this),
        showBio: (function(_this) {
          return function(artist) {
            var bioCollection;
            _this.artist = artist;
            App.BioApp.Show.Controller.url = artist;
            bioCollection = new App.Entities.BioElementTextCollection;
            bioCollection.fetch({
              'success': function(response) {
                _this.showView = new View.ShowViews({
                  collection: response
                });
                return App.bioRegion.show(_this.showView);
              }
            });
          };
        })(this)
      };
    });
    return App.BioApp.Show.Controller;
  });

}).call(this);
