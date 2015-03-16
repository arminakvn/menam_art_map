(function() {
  define(["js/app", "tpl!js/apps/map_app/show/templates/show_view.tpl"], function(App, showTpl) {
    App.module("MapApp.View", function(View, App, Backbone, Marionette, $, _) {
      return View.ShowView = Marionette.ItemView.extend({
        template: showTpl,
        id: "location-region",
        tagName: "div",
        onShow: function() {
          var textResponse;
          textResponse = $.ajax({
            url: "/artistsbygroup/1",
            success: (function(_this) {
              return function(result) {
                return result;
              };
            })(this)
          });
          return $.when(textResponse).done((function(_this) {
            return function(artists) {
              var artist, circle, color, each, eachcnt, fx, i, id, ltlong, nodeGroup, nodes, _i, _j, _len, _len1, _links, _nodes, _ref;
              id = 0;
              _this.artistNodes = [];
              nodes = [];
              for (_i = 0, _len = artists.length; _i < _len; _i++) {
                artist = artists[_i];
                nodes.push(artist);
                _this.artistNodes.push({
                  'name': artist.source,
                  'id': id,
                  'group': artist.group
                });
                id = id + 1;
              }
              _links = nodes;
              _links.sort(function(a, b) {
                if (a.source > b.source) {
                  return 1;
                } else if (a.source < b.source) {
                  return -1;
                } else {
                  if (a.target > b.target) {
                    return 1;
                  }
                  if (a.target < b.target) {
                    return -1;
                  } else {
                    return 0;
                  }
                }
              });
              i = 0;
              while (i < _links.length) {
                if (i !== 0 && _links[i].source === _links[i - 1].source && _links[i].target === _links[i - 1].target) {
                  _links[i].linknum = _links[i - 1].linknum + 1;
                } else {
                  _links[i].linknum = 1;
                }
                i++;
              }
              _nodes = {};
              _links.forEach(function(link) {
                link.source = _nodes[link.source] || (_nodes[link.source] = {
                  name: link.source,
                  value: 1
                });
                link.target = _nodes[link.target] || (_nodes[link.target] = {
                  name: link.target,
                  group: link.group,
                  lat: link.lat,
                  long: link.long,
                  value: 1
                });
              });
              d3.values(_nodes).forEach(function(sourceNode) {
                _links.forEach(function(link) {
                  if (link.source.name === sourceNode.name && link.target.name !== sourceNode.name) {
                    link.target.value += 1;
                  }
                });
              });
              L.mapbox.accessToken = "pk.eyJ1IjoiYXJtaW5hdm4iLCJhIjoiSTFteE9EOCJ9.iDzgmNaITa0-q-H_jw1lJw";
              _this._m = L.mapbox.map("map", "arminavn.jhehgjan", {
                zoomAnimation: true,
                dragAnimation: true,
                attributionControl: false,
                zoomAnimationThreshold: 10,
                inertiaDeceleration: 4000,
                animate: true,
                duration: 1.75,
                zoomControl: false,
                doubleClickZoom: false,
                infoControl: false,
                easeLinearity: 0.1,
                maxZoom: 5
              });
              _this._m.setView([42.34, 0.12], 3);
              _this._m.boxZoom.enable();
              _this._m.scrollWheelZoom.disable();
              _this._m.on("click", function() {
                _this.nodeGroup.eachLayer(function(layer) {
                  return layer.setStyle({
                    opacity: 0.1,
                    fillOpacity: 0.1,
                    clickable: false
                  });
                });
                _this._m.setView([42.34, 0.12], 3);
              });
              _this._nodes = _nodes;
              _this._links = _links;
              App.MapApp.Show.Controller._links = _links;
              eachcnt = 0;
              nodeGroup = L.layerGroup([]);
              _this.color = d3.scale.category10();
              color = _this.color;
              _this.popupGroup = L.layerGroup([]);
              _this.popupGroup.addTo(_this._m);
              _ref = d3.values(_nodes);
              for (_j = 0, _len1 = _ref.length; _j < _len1; _j++) {
                each = _ref[_j];
                eachcnt = 1 + eachcnt;
                try {
                  if (each.group === 1 && each.lat) {
                    ltlong = new L.LatLng(+each.lat, +each.long);
                    circle = new L.CircleMarker(ltlong, {
                      color: "blue",
                      opacity: 0.5,
                      fillOpacity: 0.5,
                      weight: 1,
                      className: "" + (eachcnt - 1),
                      id: "" + each.name,
                      clickable: true
                    }).setRadius(Math.sqrt(each.value) * 5).bindPopup("<p style='font-size:12px; line-height:10px; font-style:bold;'><a>" + each.name + "</p><p style='font-size:12px; font-style:italic; line-height:10px;'>" + (each.value - 1) + " artists connected to this location</p>");
                    nodeGroup.addLayer(circle);
                  }
                } catch (_error) {}
              }
              nodeGroup.eachLayer(function(layer) {
                _this.markers = new L.MarkerClusterGroup([], {
                  maxZoom: 8,
                  spiderfyOnMaxZoom: true,
                  zoomToBoundsOnClick: true,
                  spiderfyDistanceMultiplier: 2
                });
                _this.markers.addTo(_this._m);
                layer.on("click", function(e) {
                  _this.markers.clearLayers();
                  return textResponse = $.ajax({
                    url: "/artstsby/" + layer.options.id,
                    success: function(nodes) {
                      var currentzoom, marker;
                      currentzoom = _this._m.getZoom();
                      marker = new L.CircleMarker([]);
                      return nodes.forEach(function(artist) {
                        var artistNode;
                        artistNode = new L.LatLng(+artist.lat, +artist.long);
                        marker = new L.CircleMarker(artistNode, {
                          color: d3.lab("blue").darker(-2),
                          opacity: 0.5,
                          fillOpacity: 0.5,
                          weight: 1,
                          clickable: true
                        }).setRadius(7).bindPopup("<p>" + artist.source + "</p>");
                        return _this.markers.addLayer(marker);
                      });
                    }
                  });
                });
              });
              nodeGroup.addTo(_this._m);
              _this.nodeGroup = nodeGroup;
              App.MapApp.Show.Controller.nodeGroup = nodeGroup;
              App.MapApp.Show.Controller.markers = _this.markers;
              App.MapApp.Show.Controller.popupGroup = _this.popupGroup;
              return fx = new L.PosAnimation();
            };
          })(this));
        }
      });
    });
    return App.MapApp.View;
  });

}).call(this);
