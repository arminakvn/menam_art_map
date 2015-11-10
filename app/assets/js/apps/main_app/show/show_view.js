(function() {
  define(["js/app", "tpl!js/apps/main_app/show/templates/show_view.tpl", "tpl!js/apps/main_app/show/templates/show_views.tpl", "tpl!js/apps/main_app/show/templates/spider_view.tpl", "tpl!js/apps/main_app/show/templates/credit_view.tpl"], function(App, showTpl, showTpls, spiderTpl, creditTpl) {
    App.module("MainApp.View", function(View, App, Backbone, Marionette, $, _) {
      View.SpiderView = Marionette.CollectionView.extend({
        template: spiderTpl,
        id: 'bios-list',
        $el: $('#bios-list')
      });
      View.CreditView = Marionette.ItemView.extend({
        template: creditTpl,
        tagName: "div",
        $el: $('#bio-region'),
        className: 'bio-region'
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
          App.navigate("#/location/", {
            trgigger: true
          });
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
          $("document").ready(function() {
            console.log($('#bodyContainer').innerHeight());
            console.log("$('#headerContainer').innerHeight() ", $('#headerContainer').innerHeight());
            console.log($('#navigationContainer').innerHeight());
            $('#bios-list').css("height", "" + ($('#bodyContainer').innerHeight() - $('#headerContainer').innerHeight() - $('#navigationContainer').innerHeight()));
            $('#main-region').css("height", "" + ($('#bodyContainer').innerHeight() - $('#headerContainer').innerHeight() - $('#navigationContainer').innerHeight()));
            $('#bio-region').css("height", "" + ($('#bodyContainer').innerHeight() - $('#headerContainer').innerHeight() - $('#navigationContainer').innerHeight()));
            return console.log($('#bios-list').innerHeight());
          });
          return $("document").ready((function(_this) {
            return function() {
              var b_el, biosRegion, btterflyRegion, clicked, clicks, color, defs, gradient, graticule, land, mouseovered, pathG, projection, svg;
              biosRegion = _this.biosRegion;
              b_el = $("#main-region");
              btterflyRegion = b_el;
              projection = d3.geo.polyhedron.waterman().rotate([20, 0]).scale(150).translate([btterflyRegion[0].clientWidth / 2, 350]).precision(.1);
              pathG = d3.geo.path().projection(projection);
              graticule = d3.geo.graticule();
              clicks = [];
              gradient = ['black', 'red'];
              color = d3.scale.linear().domain([0, 3]).range(gradient);
              svg = d3.select('#main-region').append('svg').attr('width', btterflyRegion[0].clientWidth).attr('height', 700);
              defs = svg.append('defs');
              land = void 0;
              mouseovered = function(d) {};
              clicked = function(d) {
                var domain, p, timeout;
                p = d3.select(_this);
                clicks[d.id]++;
                domain = [d3.min(clicks), d3.max(clicks)];
                color.domain(domain);
                land.filter('.land').style('fill', function(d) {
                  return color(clicks[d.id]);
                });
                timeout = 0;
                timeout = setTimeout(function() {
                  if (timeout !== 0) {
                    return timeout = 0;
                  }
                }, 1600, function() {
                  App.execute("showBio", [d.source]);
                  return App.execute("highlightNode", [d.source]);
                });
                App.navigate("#/location/", {
                  trgigger: true
                });
              };
              defs.append('path').datum({
                type: 'Sphere'
              }).attr('id', 'sphere').attr('d', pathG);
              defs.append('clipPath').attr('id', 'clip').append('use').attr('xlink:href', '#sphere');
              svg.append('use').attr('class', 'stroke').attr('xlink:href', '#sphere');
              svg.append('use').attr('class', 'fill').attr('xlink:href', '#sphere');
              svg.append('path').datum(graticule).attr('class', 'graticule').attr('clip-path', 'url(#clip)').attr('d', pathG);
              d3.json('world-50m.json', function(error, world) {
                var polys, textResponse;
                polys = topojson.feature(world, world.objects.countries).features;
                polys.forEach(function(d) {
                  clicks[d.id] = 0;
                });
                land = svg.selectAll('path').data(polys);
                land.enter().insert('path', '.graticule').attr('class', 'land').attr('clip-path', 'url(#clip)').style('fill', function(d) {
                  return color(clicks[d.id]);
                }).attr('d', pathG).on('click', clicked).on('mouseover', mouseovered);
                textResponse = $.ajax({
                  url: "/artistsbygroup/1",
                  success: (function(_this) {
                    return function(result) {
                      return result;
                    };
                  })(this)
                });
                $.when(textResponse).done((function(_this) {
                  return function(artists) {
                    return svg.selectAll('path').data(artists).enter().append('circle', '.pin').attr('r', 2).attr('fill', 'white').attr('transform', function(d) {
                      if (d.long !== "NA") {
                        return 'translate(' + projection([d.long, d.lat]) + ')';
                      }
                    }).on('click', clicked).on('mouseover', function(d) {
                      var xPosition, yPosition;
                      xPosition = d3.select(this).attr('x');
                      yPosition = d3.select(this).attr('y');
                      d3.select('#tooltip').style('left', d3.event.pageX + 'px').style('top', d3.event.pageY - 90 + 'px').select('#-label').html('<strong>' + 'Location: ' + d.target + '</strong>' + '<br/>' + 'View Artist: ' + d.source);
                      d3.select('#tooltip').classed('hidden', false);
                    }).on('mouseout', function() {
                      d3.select('#tooltip').classed('hidden', true);
                    });
                  };
                })(this));
              });
              return d3.select(self.frameElement).style('height', btterflyRegion[0].clientHeight + 'px');
            };
          })(this));
        }
      });
    });
    return App.MainApp.View;
  });

}).call(this);
