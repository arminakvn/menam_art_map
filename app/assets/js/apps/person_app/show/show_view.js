(function() {
  define(["js/app", "tpl!js/apps/person_app/show/templates/show_view.tpl"], function(App, showTpl) {
    App.module("PersonApp.View", function(View, App, Backbone, Marionette, $, _) {
      return View.ShowView = Marionette.Layout.extend({
        template: showTpl,
        id: "person-region",
        tagName: "div",
        initialize: function() {
          var artist, i, _i, _j, _len, _len1, _ref, _ref1;
          this.nodes = [];
          _ref = App.PersonNodeCollection.models;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            artist = _ref[_i];
            this.nodes.push(artist.attributes);
          }
          this.links = [];
          _ref1 = App.PersonLinkCollection.models;
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            artist = _ref1[_j];
            this.links.push(artist.attributes);
          }
          i = 0;
          this.optArray = [];
          while (i < this.nodes.length - 1) {
            this.optArray.push(this.nodes[i].name);
            i++;
          }
          this.optArray = this.optArray.sort();
          return App.PersonApp.Show.Controller.toggle = 0;
        },
        onShow: function() {
          var color, i, link, mouseout, mouseover, node;
          this.width = this.el.clientWidth;
          this.height = this.el.clientHeight;
          if (this.height < 800) {
            this.height = 1100;
          }
          color = d3.scale.category20();
          this.svg = d3.select('#person-region').append('svg').attr('width', this.width).attr('height', this.height);
          this.force = d3.layout.force().nodes(this.nodes).links(this.links).size([this.width, this.height]).linkDistance(60).charge(-500).linkStrength(0.7).gravity(0.3).start();
          this.link = link = this.svg.selectAll('.link').data(this.force.links()).enter().append('line').attr('class', 'link').style('stroke', 'lightgray').style('stroke-width', function(d) {
            return Math.sqrt(d.value);
          });
          this.node = node = this.svg.selectAll('.node').data(this.force.nodes()).enter().append('g').attr('class', 'node').on('mouseover', mouseover).on('mouseout', mouseout).on('touchstart', mouseover).on('touchend', mouseout).call(this.force.drag).on('click', function() {
            var d;
            d = d3.select(this).node().__data__;
            return App.PersonApp.Show.Controller.connectedNodes(d);
          });
          this.tick = (function(_this) {
            return function() {
              link.attr('x1', function(d) {
                return d.source.x;
              }).attr('y1', function(d) {
                return d.source.y;
              }).attr('x2', function(d) {
                return d.target.x;
              }).attr('y2', function(d) {
                return d.target.y;
              });
              node.attr('transform', function(d) {
                return 'translate(' + d.x + ',' + d.y + ')';
              });
            };
          })(this);
          this.linkedByIndex = {};
          i = 0;
          while (i < this.nodes.length) {
            this.linkedByIndex[i + ',' + i] = 1;
            i++;
          }
          this.links.forEach((function(_this) {
            return function(d) {
              _this.linkedByIndex[d.source.index + ',' + d.target.index] = 1;
            };
          })(this));
          this.neighboring = (function(_this) {
            return function(a, b) {
              return _this.linkedByIndex[a.index + ',' + b.index];
            };
          })(this);
          mouseover = function() {
            console.log("mouseover");
            d3.select(this).select('circle').transition().duration(750).attr('r', 12);
            d3.select(this).select('text').transition().duration(750).style('font-size', '20px');
          };
          mouseout = function() {
            d3.select(this).select('circle').transition().duration(750).attr('r', 5);
            d3.select(this).select('text').transition().duration(750).style('font-size', '10px');
          };
          node.append('circle').style('fill', function(d) {
            return color(d.group);
          }).attr('r', 5);
          node.append('text').attr('x', 14).attr('dy', '.35em').text(function(d) {
            return d.name;
          });
          this.force.on('tick', this.tick).start();
          App.PersonApp.Show.Controller.node = this.node;
          App.PersonApp.Show.Controller.link = this.link;
          App.PersonApp.Show.Controller.connectedNodes = (function(_this) {
            return function(d) {
              if (App.PersonApp.Show.Controller.toggle === 0) {
                _this.node.style('opacity', function(o) {
                  if (_this.neighboring(d, o) | _this.neighboring(o, d)) {
                    return 1;
                  } else {
                    return 0.1;
                  }
                });
                _this.link.style('opacity', function(o) {
                  if (d.index === o.source.index | d.index === o.target.index) {
                    return 1;
                  } else {
                    return 0.1;
                  }
                });
                App.PersonApp.Show.Controller.toggle = 1;
              } else {
                _this.node.style('opacity', 1);
                _this.link.style('opacity', 1);
                App.PersonApp.Show.Controller.toggle = 0;
              }
            };
          })(this);
          return this.force.resume();
        }
      });
    });
    return App.PersonApp.View;
  });

}).call(this);
