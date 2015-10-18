(function() {
  define(["js/app", "tpl!js/apps/nav_app/show/templates/show_view.tpl", "tpl!js/apps/nav_app/show/templates/show_modal.tpl"], function(App, showTpl, modalTpl) {
    var ModalRegion;
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
    App.module("NavApp.View", function(View, App, Backbone, Marionette, $, _) {
      View.ShowView = Marionette.Layout.extend({
        template: showTpl,
        id: "nav",
        tagName: "div",
        "class": "artistsList list-navigator hidden",
        ui: {
          'div': 'div'
        },
        events: {
          'click #statelist': 'navigate',
          'click #statelocation': 'locations',
          'mouseover @ui.div': 'mouseoverNav',
          'mouseout @ui.div': 'mouseoutNav'
        },
        navigate: function(e) {
          return App.MainApp.Show.Controller.updateView('all');
        },
        mouseoverNav: function(e) {
          return $(e.target).css('cursor', 'pointer');
        },
        mouseoutNav: function(e) {
          return $(e.target).css('cursor', 'default');
        },
        locations: function(e) {
          return App.navigate("/", {
            trigger: true
          });
        },
        initialize: function() {},
        onShow: function() {
          this.$el.animate({
            opacity: 1
          }, 1000);
          return this.$el.removeClass("hidden");
        }
      });
      return View.ShowModal = Marionette.Layout.extend({
        template: modalTpl,
        id: "modal",
        ui: {
          'modal': 'div'
        },
        events: {
          'mouseover @ui.modal': 'mouseoverModal',
          'mouseout @ui.modal': 'mouseoutModal'
        },
        mouseoverModal: function(e) {
          return $(e.target).css('cursor', 'pointer');
        },
        mouseoutModal: function(e) {
          return $(e.target).css('cursor', 'default');
        },
        initialize: function() {},
        onShow: function() {}
      });
    });
    return App.NavApp.View;
  });

}).call(this);
