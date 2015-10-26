(function() {
  var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  define(["js/app", "tpl!js/apps/bio_app/show/templates/show_view.tpl", "tpl!js/apps/bio_app/show/templates/show_views.tpl"], function(App, showTpl, showsTpl) {
    App.module("BioApp.View", function(View, App, Backbone, Marionette, $, _) {
      View.ShowView = Marionette.ItemView.extend({
        template: showTpl,
        className: function() {
          var _ref;
          if (_ref = this.model.attributes.name, __indexOf.call(App.list, _ref) >= 0) {
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
            return App.MainApp.Show.Controller.highlightArtistsby(list);
          }
        },
        onBeforeRender: function() {
          var _ref;
          if (_ref = this.model.attributes.name, __indexOf.call(App.MapApp.Show.Controller.showView.list, _ref) >= 0) {
            this.$el.addClass('bioItem location');
          } else {
            this.$el.addClass('bioItem');
          }
          return;
          return this.$el.animate({
            opacity: 1
          }, 500);
        },
        onBeforeClose: function() {
          return this.$el.animate({
            opacity: 0
          }, 750);
        },
        mouseoutElems: function(e) {
          this.$el.css('cursor', 'default');
          this.$el.removeClass('highlighted');
          return App.MainApp.Show.Controller.resetHighlightArtistsby();
        },
        mouseclickElems: function(e) {
          var navigation, _ref;
          if (_ref = this.model.attributes.name, __indexOf.call(App.MapApp.Show.Controller.showView.list, _ref) >= 0) {
            App.MainApp.Show.Controller.updateView(this.model.attributes.name);
            App.MapApp.Show.Controller.resetMapHighlights();
            App.MapApp.Show.Controller.previewByLocation(this.$el[0].textContent);
            navigation = new App.Entity.Navigation({
              statelist: "All artists > " + this.$el[0].textContent,
              statelocation: "All locations > " + this.$el[0].textContent
            });
            App.NavApp.Show.Controller.updateNavigationLoc(navigation);
            return setTimeout(((function(_this) {
              return function() {
                App.execute("highlightPlace", _this.$el[0].textContent);
              };
            })(this)), 3000);
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
              if (_ref = _this.model.attributes.name, __indexOf.call(App.list, _ref) >= 0) {
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
          this.$el.animate({
            opacity: 0
          }, 750);
          return this.children.each((function(_this) {
            return function(childView) {
              var childModel, _ref;
              childModel = childView.model;
              if (_ref = childModel.attributes.name, __indexOf.call(App.MapApp.Show.Controller.showView.list, _ref) >= 0) {
                childView.$el.addClass('bioItem location');
              } else {
                childView.$el.addClass('bioItem');
              }
            };
          })(this));
        },
        onAfterRender: function() {
          return this.children.each((function(_this) {
            return function(childView) {
              var childModel, _ref;
              childModel = childView.model;
              if (_ref = childModel.attributes.name, __indexOf.call(App.MapApp.Show.Controller.showView.list, _ref) >= 0) {
                childView.$el.addClass('bioItem location');
              } else {
                childView.$el.addClass('bioItem');
              }
            };
          })(this));
        },
        onShow: function() {
          console.log(App);
          return this.children.each((function(_this) {
            return function(childView) {
              var childModel, _ref;
              childModel = childView.model;
              if (_ref = childModel.attributes.name, __indexOf.call(App.list, _ref) >= 0) {
                childView.$el.addClass('bioItem location');
              } else {
                childView.$el.addClass('bioItem');
              }
            };
          })(this));
        }
      });
    });
    return App.BioApp.View;
  });

}).call(this);
