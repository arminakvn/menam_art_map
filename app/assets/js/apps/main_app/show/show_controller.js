(function() {
  define(["js/app", "js/apps/main_app/show/show_view"], function(App, View) {
    App.module("MainApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      var ShowModel;
      return Show.Controller = ShowModel = {
        showView: function() {
          return require(["js/entities/artist_source"], (function(_this) {
            return function() {
              var getCollection;
              getCollection = App.request("set:collection", 'artistssource');
              return $.when(getCollection).done(function(artists) {
                var showView;
                showView = new View.ShowView();
                return App.mainRegion.show(showView);
              });
            };
          })(this));
        }
      };
    });
    return App.MainApp.Show.Controller;
  });

}).call(this);
