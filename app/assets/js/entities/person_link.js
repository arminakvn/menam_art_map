(function() {
  define(["js/app"], function(App) {
    App.module("Entities", function(Entities, App, Backbone, Marionette, $, _) {
      var API, initializePersonLink;
      Entities.PersonLinkCollection = Backbone.Collection.extend();
      Entities.PersonLink = Backbone.Model.extend();
      initializePersonLink = new Entities.PersonLink();
      API = {
        getPersonLinkEntity: function() {
          var defer;
          defer = $.Deferred();
          defer.resolve(initializePersonLink);
          return defer.promise();
        },
        setPersonLink: function(personLinks) {
          return App.PersonLinkCollection = new Entities.PersonLinkCollection(personLinks);
        }
      };
      App.reqres.setHandler("personLink", function() {
        return API.getPersonLinkEntity();
      });
      return App.reqres.setHandler("set:personLink", function(personLinks) {
        return API.setPersonLink(personLinks);
      });
    });
  });

}).call(this);
