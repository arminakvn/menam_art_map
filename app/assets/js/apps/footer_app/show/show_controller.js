(function() {
  define(["js/app", "js/apps/footer_app/show/show_view"], function(App, View) {
    App.module("FooterApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      var ShowModel;
      return Show.Controller = ShowModel = {
        showFooter: function() {
          var showView;
          showView = new View.ShowView();
          return App.footerRegion.show(showView);
        }
      };
    });
    return App.HeaderApp.Show.Controller;
  });

}).call(this);
