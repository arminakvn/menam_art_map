(function() {
  define(["js/app", "tpl!js/apps/main_app/show/templates/show_view.tpl"], function(App, showTpl) {
    App.module("MainApp.View", function(View, App, Backbone, Marionette, $, _) {
      return View.ShowView = Marionette.ItemView.extend({
        template: showTpl,
        id: 'bios',
        $el: $('#bios'),
        ui: {
          'name': '#bio-list'
        },
        initialize: function() {},
        onShow: function() {
          return $(document).ready((function(_this) {
            return function() {
              var $el, biosRegion, color, inWidth, _d3text, _el, _textDomEl, _textDomObj;
              _this.data = _.map(App.ArtistSourceCollection.models, function(key, value) {
                return _.map(key.attributes, function(key, value) {
                  return value;
                });
              });
              biosRegion = $("#bios-region");
              $el = biosRegion;
              _textDomEl = L.DomUtil.create('div', 'container paratext-info');
              _el = L.DomUtil.create('svg', 'svg');
              biosRegion.append(_textDomEl);
              L.DomUtil.enableTextSelection(_textDomEl);
              _textDomObj = $(L.DomUtil.get(_textDomEl));
              inWidth = $el[0].clientWidth / 5;
              _textDomObj.css('width', $el[0].clientWidth);
              _textDomObj.css('height', "970");
              _textDomObj.css('background-color', 'none');
              _textDomObj.css('overflow', 'auto');
              L.DomUtil.setOpacity(L.DomUtil.get(_textDomEl), .8);
              color = d3.scale.category10();
              _d3text = d3.select(".paratext-info").append("ul").style("list-style-type", "none").style("padding-left", "0px").style('overflow', 'auto').attr("id", "bios-list").attr("width", $el[0].clientWidth).attr("height", $el[0].clientHeight);
              _this._d3li = _d3text.selectAll("li").data(_this.data).enter().append("li");
              return _this._d3li.style("font-family", "Gill Sans").style("font-size", "16px").style("line-height", "1").style("border", "0px solid black").style("margin-top", "20px").style("padding-right", "20px").style("padding-left", "40px").attr("id", function(d, i) {
                return "line-" + i;
              }).on("mouseover", function(d) {
                return $(this).css('cursor', 'pointer');
              }).on("click", function(d, i) {
                L.DomEvent.disableClickPropagation(this);
                d3.select(this).transition().duration(0).style("color", "black").style("background-color", function(d, i) {
                  return "white";
                }).style("opacity", 1);
                d3.select(this).transition().duration(1000).style("color", "rgb(72,72,72)").style("background-color", (function(_this) {
                  return function(d, i) {
                    var id;
                    id = d3.select(_this).attr("id").replace("line-", "");
                    return color(1);
                  };
                })(this)).style("opacity", 1);
              }).append("text").text(function(d, i) {
                var timeout;
                _this._leafletli = L.DomUtil.get("line-" + i);
                timeout = void 0;
                L.DomEvent.addListener(_this._leafletli, 'click', function(e) {
                  d3.selectAll(_this._d3li[0]).style("color", "black").style("background-color", "white").style("opacity", 1);
                  timeout = 0;
                  timeout = setTimeout(function() {
                    if (timeout !== 0) {
                      timeout = 0;
                      return App.execute("highlightNode", d);
                    }
                  }, 600);
                }, function() {
                  return;
                  return e.stopPropagation();
                });
                return d;
              }).style("font-family", "Gill Sans").style("font-size", "14px").style("color", "black").transition().duration(1).delay(1).style("opacity", 1);
            };
          })(this));
        }
      });
    });
    return App.MainApp.View;
  });

}).call(this);
