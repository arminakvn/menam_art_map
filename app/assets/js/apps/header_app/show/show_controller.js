(function() {
  define(["js/app", "js/apps/header_app/show/show_view"], function(App, View) {
    App.module("HeaderApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      var ShowModel;
      return Show.Controller = ShowModel = {
        showHeader: function() {
          var showView;
          showView = new View.HeadersView();
          App.state = {
            "current": 0
          };
          return App.headerRegion.show(showView);
        }
      };
    });
    return App.HeaderApp.Show.Controller;
  });

}).call(this);
