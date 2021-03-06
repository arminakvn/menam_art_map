(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(["js/app", "js/apps/map_app/show/show_view"], function(App, View) {
    App.Entity.LocationNode = Backbone.Model.extend();
    App.Entity.LocationState = Backbone.Model.extend();
    App.Entities.LocationNodeCollection = Backbone.Collection.extend({
      model: App.Entity.LocationNode,
      initialize: function(url) {
        if (url === void 0) {
          this.param = "all";
          this.url = "/artistsbygroup/1";
        } else if (url === "all") {
          this.url = "/artistsbygroup/1";
        } else {
          this.param = url;
          this.url = "/artistsbysource/" + this.param.param;
        }
        this.on('request', function() {
          var target;
          target = document.getElementById('main-region');
          App.vent.trigger("spinnerLoading", target);
          console.log("loading");
        });
        this.on('sync', (function(_this) {
          return function() {
            var e;
            App.vent.trigger("spinnerLoaded");
            try {
              API.highlightNode(_this.param.param);
            } catch (_error) {
              e = _error;
              console.log("cousnrr", _this.param);
            }
            console.log("loaded");
          };
        })(this));
      },
      url: function() {
        return this.url;
      },
      parse: function(response) {
        var data;
        data = _.map(response, (function(_this) {
          return function(key, value) {
            return {
              'name': key.source,
              'group': key.group,
              'id': key._id,
              'lat': key.lat,
              'long': key.long,
              'source': key.source,
              'target': key.target,
              'value': 5
            };
          };
        })(this));
        return data;
      }
    });
    App.Entities.LocationNodeSelectedCollection = Backbone.Collection.extend();
    App.module("MapApp.Show", function(Show, App, Backbone, Marionette, $, _) {
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
        showLocationByExistingCollection: function() {
          var locationNodes;
          locationNodes = App.MapApp.Show.Controller.showView.collection;
          this.showView = new View.ShowView({
            collection: locationNodes
          });
          return App.mainRegion.show(this.showView);
        },
        previewByLocation: (function(_this) {
          return function(sourceNode) {
            var sourceNode2, updateCollection;
            sourceNode2 = sourceNode.replace(/^\s+|\s+$/g, "");
            updateCollection = $.ajax('/distLocbysourceartist/' + sourceNode.replace(/^\s+|\s+$/g, "", {
              type: 'GET',
              dataType: 'json',
              error: function(jqXHR, textStatus, errorThrown) {},
              success: function(data, textStatus, jqXHR) {
                var ret;
                return ret = _.map(data, function(key, value) {
                  return {
                    "target": value
                  };
                });
              }
            }));
            return $.when(updateCollection).done(function(respnd) {
              var each, _i, _len, _results;
              console.log("previewByLocation", respnd);
              _results = [];
              for (_i = 0, _len = respnd.length; _i < _len; _i++) {
                each = respnd[_i];
                if (each !== sourceNode.replace(/^\s+|\s+$/g, "")) {
                  _results.push(App.MapApp.Show.Controller.highlightNodesBy(each));
                } else {
                  _results.push(void 0);
                }
              }
              return _results;
            });
          };
        })(this),
        showLocation: function(source) {
          var locationNavigator, locationNodes;
          console.log("source", source);
          console.log("this is showLocation");
          locationNodes = new App.Entities.LocationNodeCollection(source);
          locationNavigator = new App.Entity.LocationState({
            'state': 'World'
          });
          return locationNodes.fetch({
            'success': (function(_this) {
              return function(response) {
                console.log("response", response);
                _this.showView = new View.ShowView({
                  collection: locationNodes,
                  model: locationNavigator
                });
                return App.mainRegion.show(_this.showView);
              };
            })(this)
          });
        },
        resetMapHighlights: (function(_this) {
          return function() {
            _this.Controller.showView.placeNodeGroup.eachLayer(function(layer) {
              return _this.Controller.showView.placeNodeGroup.removeLayer(layer);
            });
            return _this.Controller.showView.nodeGroup.eachLayer(function(layer) {
              layer.setStyle({
                opacity: 0.1,
                fillOpacity: 0.1,
                clickable: false
              });
              _this.Controller.showView._m.setView([42.34, 0.12], 3);
            });
          };
        })(this),
        showLocationByGroup: function(locationGroup) {
          return App.MainApp.Show.Controller.updateView(locationGroup);
        },
        highlightPlace: (function(_this) {
          return function(sourceNode) {
            console.log("highlightPlace", sourceNode.replace(/^\s+|\s+$/g, ""));
            return _this.Controller.showView.nodeGroup.eachLayer(function(layer) {
              var circle, ltlong, newLayerLatLong;
              if (layer.options.id === sourceNode.replace(/^\s+|\s+$/g, "")) {
                console.log("tthis is the sourcePlace", layer.options.id);
                layer.bringToFront();
                console.log("layer", layer);
                newLayerLatLong = layer._latlng;
                console.log("newLayerLatLong", newLayerLatLong);
                ltlong = new L.LatLng(+newLayerLatLong.lat, +newLayerLatLong.lng);
                circle = new L.CircleMarker(ltlong, {
                  opacity: 0.8,
                  fillOpacity: 0.5,
                  weight: 1,
                  className: 'locations-nodes place',
                  id: "" + layer.options.id,
                  clickable: true
                }).setRadius(layer.options.radius).bindPopup("<span href='#location/" + layer.options.id + "'>" + layer.options.id + "</span>");
                _this.Controller.showView.placeNodeGroup.addLayer(circle);
                return _this.Controller.showView.placeNodeGroup.addTo(_this.Controller.showView._m);
              }
            });
          };
        })(this),
        highlightNodesBy: (function(_this) {
          return function(sourceNode) {
            var updateCollection;
            updateCollection = $.ajax('/artistsbysource/' + sourceNode, {
              type: 'GET',
              dataType: 'json',
              error: function(jqXHR, textStatus, errorThrown) {},
              success: function(data, textStatus, jqXHR) {
                var ret;
                return ret = _.map(data, function(key, value) {
                  return {
                    "target": key.target
                  };
                });
              }
            });
            $.when(updateCollection).done(function(respnd) {
              var e, output;
              output = [];
              try {

              } catch (_error) {
                e = _error;
              }
              App.MapApp.Show.Controller.showView.collection.each(function(initmodels) {
                return output.push(initmodels.get('target').name);
              });
              App.MapApp.Show.Controller.showView.children.each(function(childView) {
                var childModel;
                return childModel = childView.model;
              });
              return respnd.forEach(function(name_res) {});
            });
            _this._sourceNode = sourceNode;
            console.log("@Controller.showView.nodeGroup", _this.Controller.showView.nodeGroup);
            _this.Controller.showView.nodeGroup.eachLayer(function(layer) {
              var timeout;
              _this.Controller.showView.popupGroup.clearLayers();
              layer.setStyle({
                opacity: 0.0,
                fillOpacity: 0.0,
                weight: 2,
                clickable: false
              });
              return timeout = 0;
            });
            $.ajax("/artistsbysource/" + sourceNode, {
              type: 'GET',
              dataType: 'json',
              error: function(jqXHR, textStatus, errorThrown) {},
              success: function(data, textStatus, jqXHR) {
                _this.Controller.showView.list = _.pluck(data, 'target');
                return _this.Controller.showView.nodeGroup.eachLayer(function(layer) {
                  var node, nodes, timeout, _i, _len, _ref;
                  if (_ref = layer.options.id, __indexOf.call(_this.Controller.showView.list, _ref) >= 0) {
                    $(L.DomUtil.get(layer._container)).addClass('highlighted');
                    layer.bringToFront();
                    nodes = _this.Controller.showView._m._layers;
                    for (_i = 0, _len = nodes.length; _i < _len; _i++) {
                      node = nodes[_i];
                      node.options.className = 'locations-nodes highlighted';
                      return;
                    }
                    $(L.DomUtil.get(layer._path)).addClass('artistshighleted');
                    $(_this.Controller.showView._m._layers[layer._leaflet_id]._container.lastChild).addClass('highlighted');
                    timeout = 0;
                    return setTimeout((function() {
                      return $(L.DomUtil.get(layer._container)).animate({
                        fillOpacity: 0.5,
                        opacity: 0.6
                      }, 1, function() {
                        return layer.setStyle({
                          className: 'locations-nodes highlighted',
                          fillOpacity: 0.5,
                          weight: 2,
                          opacity: 0.6,
                          clickable: true
                        });
                      });
                    }));
                  }
                });
              }
            });
          };
        })(this)
      };
    });
    return App.MapApp.Show.Controller;
  });

}).call(this);
