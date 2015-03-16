(function() {
  define(["js/app", "js/apps/header_app/show/show_view"], function(App, View) {
    App.module("HeaderApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      var ShowModel;
      return Show.Controller = ShowModel = {
        showHeader: function() {
          return require(["js/entities/header"], function() {
            var getHeader;
            getHeader = App.request("header:entities");
            return $.when(getHeader).done(function(header) {
              var showView;
              showView = new View.HeadersView({
                collection: header
              });
              return App.headerRegion.show(showView);
            });
          });
        }
      };
    });
    return App.HeaderApp.Show.Controller;
  });

}).call(this);
