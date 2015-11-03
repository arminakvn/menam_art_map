(function() {
  define(["js/app", "tpl!js/apps/main_app/show/templates/show_view.tpl", "tpl!js/apps/main_app/show/templates/show_views.tpl", "tpl!js/apps/main_app/show/templates/spider_view.tpl"], function(App, showTpl, showTpls, spiderTpl) {
    App.module("MainApp.View", function(View, App, Backbone, Marionette, $, _) {
      View.SpiderView = Marionette.CollectionView.extend({
        template: spiderTpl,
        id: 'bios-list',
        $el: $('#bios-list')
      });
      View.ShowView = Marionette.ItemView.extend({
        template: showTpl,
        tagName: "div",
        ui: {
          'name': 'li'
        },
        $el: $('li'),
        className: 'artistsList',
        events: {
          'mouseover @ui.name': 'mouseoverNames',
          'mouseout @ui.name': 'mouseoutNames',
          'click @ui.name': 'clickNames'
        },
        modelEvents: {
          'change': 'render'
        },
        mouseoverNames: function(e) {
          $(e.target).css('cursor', 'pointer');
          $('.highlighted').removeClass('highlighted');
          $('.bioTriggerd').removeClass('bioTriggerd');
          $(e.target).addClass('highlighted bioTriggerd');
          return $(e.target).addClass('highlighted');
        },
        mouseoutNames: function(e) {
          this.timeout = 0;
          this.timeout1 = 0;
          $(e.target).css('cursor', 'default');
          return $(e.target).removeClass('bioTriggerd');
        },
        clickNames: function(e) {
          var navigation, statelist;
          console.log("state in main", App.state.current);
          if (App.state.current === 0) {
            navigation = new App.Entity.Navigation({
              statelist: "" + e.target.id,
              statelocation: "All locations > " + e.target.id,
              statebio: "" + e.target.id
            });
            App.execute("showBio", e.target.id);
            App.NavApp.Show.Controller.updateNavigation(e.target.id);
            statelist = App.NavApp.Show.Controller.showView.model.attributes.statelist;
            navigation = new App.Entity.Navigation({
              statelist: "" + statelist,
              statelocation: "All locations > " + e.target.id
            });
            App.NavApp.Show.Controller.updateNavigationLoc(navigation);
            $('.highlighted').removeClass('highlighted');
            $('.bioTriggerd').removeClass('bioTriggerd');
            $(e.target).addClass('highlighted bioTriggerd');
            return App.execute("highlightNode", e.target.id);
          } else {
            App.execute("showBio", e.target.id);
            $('.highlighted').removeClass('highlighted');
            $('.bioTriggerd').removeClass('bioTriggerd');
            statelist = App.NavApp.Show.Controller.showView.model.attributes.statelist;
            navigation = new App.Entity.Navigation({
              statelist: "" + statelist,
              statelocation: "All organizations > " + e.target.id
            });
            App.NavApp.Show.Controller.updateNavigationLoc(navigation);
            return App.navigate("#/organization/" + e.target.id, {
              trgigger: true
            });
          }
        },
        onBeforeRender: function() {
          return this.$el.css("opacity", 0);
        },
        onBeforeDestroy: function() {
          return this.$el.animate({
            "opacity": 0
          }, 2000, (function(_this) {
            return function() {};
          })(this));
        },
        onShow: function() {
          $(".hoverdots").hide();
          return this.$el.animate({
            "opacity": 1
          }, 1000, (function(_this) {
            return function() {};
          })(this));
        }
      });
      return View.ShowViews = Marionette.CompositeView.extend({
        itemView: View.ShowView,
        template: showTpls,
        id: 'bios-list',
        $el: $('#bios-list'),
        ui: {
          'list': 'ul',
          'divs': 'div',
          'navigator': 'span'
        },
        events: {
          'mouseover @ui.divs': 'mouseEnterDivs',
          'mouseover @ui.navigator': 'mouseoverNavigator',
          'click @ui.navigator': 'clickNavigator'
        },
        modelEvents: {
          "model:change": "doSomething"
        },
        doSomething: function() {},
        mouseoverNavigator: function(e) {
          return $(e.target).css('cursor', 'pointer');
        },
        clickNavigator: function(e) {
          App.MainApp.Show.Controller.updateView('all');
          return App.MapApp.Show.Controller.resetMapHighlights();
        },
        mouseoutDivs: function(e) {
          return $(".hoverdots").show().fadeOut();
        },
        initialize: function() {
          return Marionette.bindEntityEvents(this, this.model, this.modelEvents);
        },
        onBeforeRender: function() {
          var height;
          console.log(window);
          height = window.screen.availHeight - window.screen.availTop;
          this.biosRegion = $("#bios-region");
          return this.$el.css("height", "" + height).css("list-style-type", "none").css('overflow', 'scroll');
        },
        onBeforeRemoveChild: function() {},
        buildChildView: function(child, ChildViewClass, childViewOptions) {
          var options, view;
          options = _.extend({
            model: child
          }, childViewOptions);
          view = new ChildViewClass(options);
          return view;
        },
        onBeforeAddChild: function() {},
        onRenderCollection: function() {
          return console.log("on render collection", $('#bio-region'));
        },
        onShow: function() {
          return $("document").ready(function() {
            console.log($('#bio-region'));
            console.log("" + ($('#bio-region').innerHeight()));
            $('#bios-list').css("height", "" + ($('#bio-region').innerHeight()));
            $('#main-region').css("height", "" + ($('#bio-region').innerHeight()));
            return $('#bio-region').css("height", "" + ($('#bio-region').innerHeight()));
          });
        }
      });
    });
    return App.MainApp.View;
  });

}).call(this);
