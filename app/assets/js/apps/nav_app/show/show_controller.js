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
        updateNavigationArtist: function(navigation) {
          var nav;
          console.log("navigation", navigation);
          App.NavApp.Show.Controller.showView.model.destroy();
          nav = new App.Entity.ArtistListState({
            statelist: navigation.attributes.statelist,
            statelocation: navigation.attributes.statelocation,
            statebio: navigation.attributes.statebio
          });
          this.showView = new View.ShowView({
            model: nav
          });
          return App.navRegion.show(this.showView);
        },
        updateNavigationLoc: function(navigation) {
          var nav;
          console.log("navigation", navigation);
          App.NavApp.Show.Controller.showView.model.destroy();
          nav = new App.Entity.ArtistListState({
            statelist: navigation.attributes.statelist,
            statelocation: navigation.attributes.statelocation,
            statebio: navigation.attributes.statebio
          });
          this.showView = new View.ShowView({
            model: nav
          });
          return App.navRegion.show(this.showView);
        },
        updateNavigationBio: function(navigation) {
          var nav;
          App.NavApp.Show.Controller.showView.model.destroy();
          nav = new App.Entity.ArtistListState({
            statelist: navigation.attributes.statelist,
            statelocation: navigation.attributes.statelocation,
            statebio: navigation.attributes.statebio
          });
          this.showView = new View.ShowView({
            model: nav
          });
          return App.navRegion.show(this.showView);
        },
        updateNavigation: function(names) {},
        showModal: function() {}
      };
    });
    return App.NavApp.Show.Controller;
  });

}).call(this);
