define ["js/app"], (App) ->
  App.module "Entities", (Entities, App, Backbone, Marionette, $, _) ->
    Entities.PersonNode = Backbone.Model.extend(
    )
    Entities.PersonNodeCollection = Backbone.Collection.extend(
      initialize:  ->
        @on 'request', ->
          # MfiaClient.app.trigger 'loading'
          console.log "loading"
          return
        @on 'sync', ->
          # MfiaClient.app.trigger 'loaded'
          console.log "loaded"
          return
        return
      url:-> 
        return "/nodes"
      
      parse: (response) ->
        # console.log "response", response
        data = _.map response, (key, value) =>
          # _.map key, (key, value) =>
            # key
          "name": key
        data

    )
    
    initializePersonNode = new Entities.PersonNode(
    )

    API =
      getPersonNodeEntity: ->
        defer = $.Deferred()
        defer.resolve initializePersonNode
        defer.promise()

      setPersonNode: (personNodes) ->
        App.PersonNodeCollection = new Entities.PersonNodeCollection personNodes


    App.reqres.setHandler "personNode", ->
      API.getPersonNodeEntity()

    App.reqres.setHandler "set:personNode", (personNodes) ->
      API.setPersonNode personNodes

  return