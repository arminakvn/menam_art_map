(function() {
  define(["js/app", "js/apps/person_app/show/show_view"], function(App, View) {
    App.module("PersonApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      return Show.Controller = {
        showPerson: function() {
          if (this.showView === void 0) {
            this.showView = new View.ShowView();
          }
          return App.mainRegion.show(this.showView);
        }
      };
    });
    return App.PersonApp.Show.Controller;
  });

}).call(this);
