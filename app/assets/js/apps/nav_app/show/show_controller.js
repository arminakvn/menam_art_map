(function() {
  define(["js/app", "js/apps/nav_app/show/show_view"], function(App, View) {
    var ModalRegion;
    App.Entity.Navigation = Backbone.Model.extend();
    ModalRegion = Backbone.Marionette.Region.extend({
      el: '#modal',
      constructor: function() {
        _.bindAll(this);
        Backbone.Marionette.Region.prototype.constructor.apply(this, arguments);
        this.on('view:show', this.showModal, this);
      },
      getEl: function(selector) {
        var $el;
        $el = $(selector);
        $el.on('hidden', this.close);
        return $el;
      },
      showModal: function(view) {
        view.on('close', this.hideModal, this);
        this.$el.modal('show');
      },
      hideModal: function() {
        this.$el.modal('hide');
      }
    });
    App.module("NavApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      return Show.Controller = {
        showNavigation: function() {
          var navigation;
          navigation = new App.Entity.Navigation({
            statelist: "All artists",
            statelocation: "All locations",
            statebio: ""
          });
          this.showView = new View.ShowView({
            model: navigation
          });
          return App.navRegion.show(this.showView);
        },
        updateNavigation: function(navigation) {
          this.showView = new View.ShowView({
            model: navigation
          });
          return App.navRegion.show(this.showView);
        },
        showModal: function() {
          App.addRegions({
            modal: new ModalRegion()
          });
          this.showModal = new View.ShowModal();
          return App.modal.show(this.showModal);
        }
      };
    });
    return App.NavApp.Show.Controller;
  });

}).call(this);
