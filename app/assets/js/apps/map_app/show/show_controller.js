(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(["js/app", "js/apps/map_app/show/show_view"], function(App, View) {
    App.module("MapApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      return Show.Controller = {
        showLocation: function() {
          if (this.showView === void 0) {
            this.showView = new View.ShowView();
          }
          return App.mainRegion.show(this.showView);
        },
        highlightNodesBy: (function(_this) {
          return function(sourceNode) {
            _this._sourceNode = sourceNode;
            _this.Controller.showView.nodeGroup.eachLayer(function(layer) {
              var timeout;
              _this.Controller.showView.popupGroup.clearLayers();
              layer.setStyle({
                opacity: 0.0,
                fillOpacity: 0.0,
                weight: 2,
                clickable: false
              });
              timeout = 0;
              return _this.Controller.showView.markers.eachLayer(function(layer) {
                return layer.setStyle({
                  opacity: 0.1,
                  fillOpacity: 0.1,
                  clickable: false
                });
              });
            });
            return $.ajax("/artistsbysource/" + sourceNode[0], {
              type: 'GET',
              dataType: 'json',
              error: function(jqXHR, textStatus, errorThrown) {},
              success: function(data, textStatus, jqXHR) {
                var list;
                list = _.pluck(data, 'target');
                return _this.Controller.showView.nodeGroup.eachLayer(function(layer) {
                  var ltlng, popup, timeout, _ref;
                  if (_ref = layer.options.id, __indexOf.call(list, _ref) >= 0) {
                    popup = new L.Popup();
                    ltlng = new L.LatLng(layer._latlng.lat, layer._latlng.lng);
                    popup.setLatLng(ltlng);
                    popup.setContent("");
                    popup.setContent(layer.options.id);
                    _this.Controller.showView.popupGroup.addLayer(popup);
                    layer.bringToFront();
                    timeout = 0;
                    return setTimeout((function() {
                      return $(L.DomUtil.get(layer._container)).animate({
                        fillOpacity: 0.8,
                        opacity: 0.9
                      }, 1, function() {
                        return layer.setStyle({
                          fillOpacity: 0.8,
                          weight: 2,
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
