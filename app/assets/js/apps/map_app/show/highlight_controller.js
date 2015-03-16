(function() {
  define(["js/app", "js/apps/map_app/show/show_view"], function(App, View) {
    App.module("MapApp.Highlight", function(Highlight, App, Backbone, Marionette, $, _) {
      var timeout;
      Highlight.Controller = {
        highlightNodesBy: (function(_this) {
          return function(sourceNode) {
            Highlight._sourceNode = sourceNode;
            return View.nodeGroup.eachLayer(function(layer) {
              View.popupGroup.clearLayers();
              return layer.setStyle({
                opacity: 0.4,
                fillOpacity: 0.4,
                weight: 2,
                clickable: false
              });
            });
          };
        })(this)
      };
      return timeout = 0;
    });
    this._links.forEach(function(link) {
      if (link.source.name === Highlight._sourceNode) {
        View.markers.eachLayer((function(_this) {
          return function(layer) {
            return layer.setStyle({
              opacity: 0.6,
              clickable: true
            });
          };
        })(this));
        return View.nodeGroup.eachLayer((function(_this) {
          return function(layer) {
            var ltlng, popup, timeout;
            if (layer.options.className === ("" + link.target.index)) {
              popup = new L.Popup();
              ltlng = new L.LatLng(layer._latlng.lat, layer._latlng.lng);
              popup.setLatLng(ltlng);
              popup.setContent("");
              popup.setContent(layer.options.id);
              View.popupGroup.addLayer(popup);
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
          };
        })(this));
      }
    });
    return App.MapApp.Highlight.Controller;
  });

}).call(this);
