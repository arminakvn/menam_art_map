(function() {
  define(["js/app", "tpl!js/apps/map_app/show/templates/show_item_view.tpl", "tpl!js/apps/map_app/show/templates/show_view.tpl"], function(App, showItemTpl, showTpl) {
    App.module("MapApp.View", function(View, App, Backbone, Marionette, $, _) {
      View.ShowItemView = Marionette.ItemView.extend({
        template: showItemTpl
      });
      return View.ShowView = Marionette.CompositeView.extend({
        itemView: View.ShowItemView,
        template: showTpl,
        id: "map",
        tagName: "div",
        onBeforeRender: function() {
          return this.$el.animate({
            opacity: 1
          }, 500);
        },
        onBeforeClose: function() {
          return this.$el.animate({
            opacity: 0
          }, 750);
        },
        onShow: function() {
          var artist, circle, color, e, each, eachcnt, fx, i, id, list, ltlong, model, nodeGroup, nodes, removeDuplicates, _i, _j, _k, _len, _len1, _len2, _links, _nodes, _ref, _ref1, _ref2;
          removeDuplicates = function(ar) {
            var key, res, value, _i, _ref, _results;
            if (ar.length === 0) {
              return [];
            }
            res = {};
            for (key = _i = 0, _ref = ar.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; key = 0 <= _ref ? ++_i : --_i) {
              res[ar[key]] = ar[key];
            }
            _results = [];
            for (key in res) {
              value = res[key];
              _results.push(value);
            }
            return _results;
          };
          list = [];
          _ref = this.collection.models;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            model = _ref[_i];
            try {
              list.push(model.attributes.target);
            } catch (_error) {
              e = _error;
            }
          }
          this.list = list;
          id = 0;
          this.artistNodes = [];
          nodes = [];
          _ref1 = this.collection.models;
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            artist = _ref1[_j];
            nodes.push(artist);
            this.artistNodes.push({
              'name': artist.attributes.source,
              'id': id,
              'group': artist.attributes.group
            });
            id = id + 1;
          }
          _links = this.collection.models;
          _links.sort(function(a, b) {
            if (a.attributes.source > b.attributes.source) {
              return 1;
            } else if (a.attributes.source < b.attributes.source) {
              return -1;
            } else {
              if (a.attributes.target > b.attributes.target) {
                return 1;
              }
              if (a.attributes.target < b.attributes.target) {
                return -1;
              } else {
                return 0;
              }
            }
          });
          i = 0;
          while (i < _links.length) {
            if (i !== 0 && _links[i].attributes.source === _links[i - 1].attributes.source && _links[i].attributes.target === _links[i - 1].attributes.target) {
              _links[i].linknum = _links[i - 1].linknum + 1;
            } else {
              _links[i].linknum = 1;
            }
            i++;
          }
          _nodes = {};
          this.collection.models.forEach(function(link) {
            link.attributes.source = _nodes[link.attributes.source] || (_nodes[link.attributes.source] = {
              name: link.attributes.source,
              value: 1
            });
            return link.attributes.target = _nodes[link.attributes.target] || (_nodes[link.attributes.target] = {
              name: link.attributes.target,
              group: link.attributes.group,
              lat: link.attributes.lat,
              long: link.attributes.long,
              value: 1
            });
          });
          d3.values(_nodes).forEach((function(_this) {
            return function(sourceNode) {
              _this.collection.models.forEach(function(link) {
                if (link.attributes.source.name === sourceNode.name && link.attributes.target.name !== sourceNode.name) {
                  link.attributes.target.value += 1;
                }
              });
              return;
            };
          })(this));
          L.mapbox.accessToken = "pk.eyJ1IjoiYXJtaW5hdm4iLCJhIjoiSTFteE9EOCJ9.iDzgmNaITa0-q-H_jw1lJw";
          this._m = L.mapbox.map("map", "arminavn.jhehgjan", {
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
          this._m.setView([42.34, 0.12], 3);
          this._m.boxZoom.enable();
          this._m.scrollWheelZoom.disable();
          this._m.on("click", (function(_this) {
            return function() {
              _this.placeNodeGroup.eachLayer(function(layer) {
                return _this.placeNodeGroup.removeLayer(layer);
              });
              _this.nodeGroup.eachLayer(function(layer) {
                return layer.setStyle({
                  opacity: 0.1,
                  fillOpacity: 0.1,
                  clickable: false
                });
              });
              _this._m.setView([42.34, 0.12], 3);
            };
          })(this));

          /*
          making the bios controller
           */
          this._nodes = _nodes;
          this._links = _links;
          App.MapApp.Show.Controller._links = _links;
          eachcnt = 0;
          nodeGroup = L.layerGroup([]);
          this.placeNodeGroup = L.layerGroup([]);
          this.color = d3.scale.category10();
          color = this.color;
          this.popupGroup = L.layerGroup([]);
          this.popupGroup.addTo(this._m);
          _ref2 = d3.values(_nodes);
          for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
            each = _ref2[_k];
            eachcnt = 1 + eachcnt;
            try {
              if (each.group === 1 && each.lat) {
                ltlong = new L.LatLng(+each.lat, +each.long);
                circle = new L.CircleMarker(ltlong, {
                  opacity: 0.5,
                  fillOpacity: 0.5,
                  weight: 1,
                  className: 'locations-nodes',
                  id: "" + each.name,
                  clickable: true
                }).setRadius(Math.sqrt(each.value) * 3).bindPopup("<span href='#location/" + each.name + "'>" + each.name + "</span>");
                nodeGroup.addLayer(circle);
              }
            } catch (_error) {}
          }
          nodeGroup.eachLayer((function(_this) {
            return function(layer) {
              layer.on("mouseover", function(e) {
                list = App.MapApp.Show.Controller.listLevelOne(layer.options.id);
                App.MainApp.Show.Controller.highlightArtistsby(list);
                return e.target.openPopup();
              });
              layer.on("mouseout", function(e) {
                App.MainApp.Show.Controller.resetHighlightArtistsby();
                return e.target.closePopup();
              });
              return layer.on("click", function(e) {
                var navigation, statelocation;
                statelocation = App.NavApp.Show.Controller.showView.model.attributes.statelocation;
                App.MainApp.Show.Controller.updateView(layer.options.id);
                App.MapApp.Show.Controller.resetMapHighlights();
                App.MapApp.Show.Controller.previewByLocation(layer.options.id);
                App.MapApp.Show.Controller.highlightPlace(layer.options.id);
                navigation = new App.Entity.Navigation({
                  statelist: "All artists > " + layer.options.id,
                  statelocation: "All locations > " + layer.options.id
                });
                return App.NavApp.Show.Controller.updateNavigationLoc(navigation);
              });
            };
          })(this));
          nodeGroup.addTo(this._m);
          this.nodeGroup = nodeGroup;
          this.model = this.nodeGroup;
          App.MapApp.Show.Controller.nodeGroup = nodeGroup;
          App.MapApp.Show.Controller.markers = this.markers;
          App.MapApp.Show.Controller.popupGroup = this.popupGroup;
          return fx = new L.PosAnimation();
        }
      });
    });
    return App.MapApp.View;
  });

}).call(this);
