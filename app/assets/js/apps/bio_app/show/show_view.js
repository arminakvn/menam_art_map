(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(["js/app", "tpl!js/apps/bio_app/show/templates/show_view.tpl", "tpl!js/apps/bio_app/show/templates/show_views.tpl"], function(App, showTpl, showsTpl) {
    App.module("BioApp.View", function(View, App, Backbone, Marionette, $, _) {
      View.ShowView = Marionette.ItemView.extend({
        template: showTpl,
        className: function() {
          var _ref;
          if (_ref = this.model.attributes.name, __indexOf.call(App.MapApp.Show.Controller.showView.list, _ref) >= 0) {
            return 'bioItem location';
          } else {
            return 'bioItem';
          }
        },
        tagName: 'span',
        id: 'bioItem',
        $el: $("#bioItem"),
        ui: {
          'elems': 'span'
        },
        events: {
          'mouseover @ui.elems': 'mouseoverElems',
          'mouseout @ui.elems': 'mouseoutElems',
          'click @ui.elems': 'mouseclickElems'
        },
        mouseoverElems: function(e) {
          var list;
          this.$el.css('cursor', 'pointer');
          if (this.$el.hasClass("location")) {
            this.$el.addClass('highlighted');
            list = App.BioApp.Show.Controller.listLevelOne(this.$el[0].textContent);
            App.MainApp.Show.Controller.highlightArtistsby(list);
            return App.MapApp.Show.Controller.previewByLocation(this.$el[0].textContent);
          }
        },
        mouseoutElems: function(e) {
          this.$el.css('cursor', 'default');
          this.$el.removeClass('highlighted');
          return App.MainApp.Show.Controller.resetHighlightArtistsby();
        },
        mouseclickElems: function(e) {
          var _ref;
          if (_ref = this.model.attributes.name, __indexOf.call(App.MapApp.Show.Controller.showView.list, _ref) >= 0) {
            App.MainApp.Show.Controller.updateView(this.model.attributes.name);
            return App.MapApp.Show.Controller.resetMapHighlights();
          }
        },
        onShow: function() {
          var myTimeout1, timedText;
          timedText = function() {
            setTimeout(myTimeout1, 200);
          };
          return myTimeout1 = (function(_this) {
            return function() {
              var _ref;
              if (_ref = _this.model.attributes.name, __indexOf.call(App.MapApp.Show.Controller.showView.list, _ref) >= 0) {
                _this.$el.addClass('bioItem location');
              } else {
                _this.$el.addClass('bioItem');
              }
            };
          })(this);
        }
      });
      return View.ShowViews = Marionette.CompositeView.extend({
        itemView: View.ShowView,
        template: showsTpl,
        className: 'bioView',
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
        onShow: function() {}
      });
    });
    return App.BioApp.View;
  });

}).call(this);
