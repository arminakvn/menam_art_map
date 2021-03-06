(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(["js/app", "js/apps/main_app/show/show_view"], function(App, View) {
    App.Entity.ArtistListState = Backbone.Model.extend();
    App.Entity.ArtistSource = Backbone.Model.extend();
    App.Entities.ArtistSourceCollection = Backbone.Collection.extend({
      model: App.Entity.ArtistSource,
      initialize: function() {
        this.on('request', function() {
          var target;
          console.log("on request before spinnerLoading");
          target = document.getElementById('bios-region');
          App.vent.trigger("spinnerLoading", target);
          console.log("loading");
        });
        this.on('sync', function() {
          App.vent.trigger("spinnerLoaded");
          App.trigger("spinnerLoaded");
          console.log("loaded");
        });
      },
      url: function() {
        var full_url, new_url;
        if (this.showView !== void 0) {
          new_url = 'sourceByTarget/' + this.showView.names;
          full_url = new_url;
          return full_url;
        } else {
          full_url = 'sourceByTarget/all';
          return full_url;
        }
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
    App.Entities.ArtistSourceSelectedCollection = Backbone.Collection.extend();
    App.module("MainApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      return Show.Controller = {
        resetHighlightArtistsby: function() {
          return App.MainApp.Show.Controller.showView.children.each((function(_this) {
            return function(childView) {
              return childView.$el.removeClass("previewHighlight");
            };
          })(this));
        },
        highlightArtistsby: function(list) {
          return $.when(list).done((function(_this) {
            return function(respnd) {
              return App.MainApp.Show.Controller.showView.children.each(function(childView) {
                var childModel, _ref;
                childModel = childView.model;
                childView.$el.removeClass("previewHighlight");
                childView.$el.removeClass("highlighted");
                childView.$el.removeClass("bioTriggerd");
                if (_ref = childModel.get('name'), __indexOf.call(respnd, _ref) >= 0) {
                  if (childView.$el.hasClass("highlighted")) {

                  } else if (childView.$el.hasClass("bioTriggerd")) {

                  } else {
                    return childView.$el.addClass("previewHighlight");
                  }
                }
              });
            };
          })(this));
        },
        updateView: function(names) {
          var updateCollection;
          updateCollection = $.ajax('/sourceByTarget/' + names, {
            type: 'GET',
            dataType: 'json',
            error: function(jqXHR, textStatus, errorThrown) {},
            success: (function(_this) {
              return function(data, textStatus, jqXHR) {
                var ret;
                return ret = _.map(data, function(key, value) {
                  return {
                    "name": key
                  };
                });
              };
            })(this)
          });
          return $.when(updateCollection).done((function(_this) {
            return function(respnd) {
              var output;
              output = [];
              App.MainApp.Show.Controller.showView.collection.each(function(initmodels) {
                return output.push(initmodels.get('name'));
              });
              App.MainApp.Show.Controller.showView.children.each(function(childView) {
                var childModel, _ref;
                childModel = childView.model;
                if (_ref = childModel.get('name'), __indexOf.call(respnd, _ref) < 0) {
                  return App.MainApp.Show.Controller.showView.collection.remove(App.MainApp.Show.Controller.showView.collection.get(childModel));
                }
              });
              return respnd.forEach(function(name_res) {
                if (__indexOf.call(output, name_res) < 0) {
                  return App.MainApp.Show.Controller.showView.collection.add(new App.Entity.ArtistSource({
                    'name': name_res
                  }));
                }
              });
            };
          })(this));
        },
        showView: function() {
          var artistssourceC, stateModel;
          stateModel = new App.Entity.ArtistListState({
            'state': 'All artists'
          });
          artistssourceC = new App.Entities.ArtistSourceCollection;
          return artistssourceC.fetch({
            'success': (function(_this) {
              return function(response) {
                _this.creditView = new View.CreditView();
                App.bioRegion.show(_this.creditView);
                _this.showView = new View.ShowViews({
                  collection: artistssourceC,
                  model: stateModel
                });
                return App.biosRegion.show(_this.showView);
              };
            })(this)
          });
        }
      };
    });
    return App.MainApp.Show.Controller;
  });

}).call(this);
