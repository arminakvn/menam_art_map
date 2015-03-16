(function() {
  define(["js/app", "tpl!js/apps/footer_app/show/templates/show_view.tpl"], function(App, showTpl) {
    App.module("FooterApp.View", function(View, App, Backbone, Marionette, $, _) {
      return View.ShowView = Marionette.ItemView.extend({
        template: showTpl
      });
    });
    return App.FooterApp.View;
  });

}).call(this);
