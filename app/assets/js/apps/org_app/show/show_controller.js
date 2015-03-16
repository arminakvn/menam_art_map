(function() {
  define(["js/app", "js/apps/org_app/show/show_view"], function(App, View) {
    App.module("OrgApp.Show", function(Show, App, Backbone, Marionette, $, _) {
      return Show.Controller = {
        showOrganization: function() {
          console.log("controller show showOrganization");
          if (this.showView === void 0) {
            this.showView = new View.ShowView();
          }
          return App.mainRegion.show(this.showView);
        },
        highlightNodesBy: function(sourceNode) {
          this._links.forEach((function(_this) {
            return function(link) {
              if (link.source.name === sourceNode.name) {
                App.OrgApp.View.vis.selectAll("circle").filter(function(d, i) {
                  return d.name === link.target.name;
                }).transition().duration(100).style("opacity", 1).attr("r", 10).style("fill", function(d) {
                  return _this.color(d.group);
                }).style("stroke", function(d) {
                  return _this.color(d.group);
                }).style("stroke-width", 4).transition().duration(900).style("opacity", 1).attr("r", 20).style("stroke", function(d) {
                  return _this.color(d.group);
                }).style("stroke-width", 1).transition().delay(50).duration(200).attr("r", function(d) {
                  if (d.group === 2) {
                    return Math.sqrt(d.value) * 20;
                  }
                }).style("stroke", function(d) {
                  return _this.color(d.group);
                }).style("fill", function(d) {
                  return _this.color(d.group);
                }).style("stroke-width", 0);
                App.OrgApp.View.vis.selectAll("text.nodetext").filter(function(d, i) {
                  return d.name === link.target.name;
                }).transition().duration(600).style("opacity", 1);
                return;
              }
            };
          })(this));
        },
        resetHighlightNodesBy: function() {
          this.vis.selectAll("circle").transition().duration(500).style("opacity", 0.6).attr("r", function(d) {
            if (d.group === 2) {
              return Math.sqrt(d.value) * 2;
            } else {
              return 2;
            }
          }).style("stroke-width", 1);
          return this.vis.selectAll("text.nodetext").transition().duration(500).style("opacity", 0);
        }
      };
    });
    return App.OrgApp.Show.Controller;
  });

}).call(this);
