(function() {
  define(["js/app", "tpl!js/apps/nav_app/show/templates/show_view.tpl"], function(App, showTpl) {
    App.module("NavApp.View", function(View, App, Backbone, Marionette, $, _) {
      return View.ShowView = Marionette.Layout.extend({
        template: showTpl,
        id: "nav",
        tagName: "div",
        "class": "artistsList list-navigator",
        ui: {
          'div': 'div'
        },
        events: {
          'click @ui.div': 'navigate',
          'mouseover @ui.div': 'mouseoverNav',
          'mouseout @ui.div': 'mouseoutNav'
        },
        navigate: function(e) {
          console.log("nav @model", this.model);
          App.MainApp.Show.Controller.updateView('all');
          return App.MapApp.Show.Controller.resetMapHighlights();
        },
        mouseoverNav: function(e) {
          return $(e.target).css('cursor', 'pointer');
        },
        mouseoutNav: function(e) {
          return $(e.target).css('cursor', 'default');
        },
        initialize: function() {},
        onShow: function() {
          return console.log("@models", this.model);
        }
      });
    });
    return App.NavApp.View;
  });

}).call(this);
