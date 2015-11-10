define ["js/app", "js/apps/main_app/show/show_view"], (App, View) ->
  App.Entity.ArtistListState = Backbone.Model.extend(
  )
  App.Entity.ArtistSource = Backbone.Model.extend(
  )
  App.Entities.ArtistSourceCollection = Backbone.Collection.extend(
    model: App.Entity.ArtistSource
    initialize:  ->
      # @queryString = options.queryString or null
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
      # console.log "queryString inside url", @showView.names
      if @showView != undefined
         new_url = 'sourceByTarget/' + @showView.names
         full_url = new_url
         full_url
      else 
        full_url = 'sourceByTarget/all'
        full_url
        
      
    parse: (response) ->
      data = _.map response, (key, value) =>
        # _.map key, (key, value) =>
          # key
        "name": key
      data

      # response.data

  )
  App.Entities.ArtistSourceSelectedCollection = Backbone.Collection.extend(
    # model: App.Entity.ArtistSource
    # initialize:  ->
    #   # @queryString = options.queryString or null
    #   @on 'request', ->
    #     # MfiaClient.app.trigger 'loading'
    #     console.log "loading"
    #     return
    #   @on 'sync', ->
    #     # MfiaClient.app.trigger 'loaded'
    #     console.log "loaded"
    #     return
    #   return

    # url: ->


    # parse: (response) ->
    #   console.log "response", response
    #   data = _.map response, (key, value) =>
    #     # _.map key, (key, value) =>
    #       # key
    #     "name": key
    #   data
  )
  App.module "MainApp.Show", (Show, App, Backbone, Marionette, $, _) ->
    Show.Controller =
      

      resetHighlightArtistsby: () ->
        App.MainApp.Show.Controller.showView.children.each (childView) =>
          childView.$el.removeClass("previewHighlight")
      highlightArtistsby: (list) ->
        $.when(list).done (respnd) =>
          # App.MainApp.Show.Controller.showView.collection.each (initmodels) =>
          #       output.push initmodels.get('name')
          App.MainApp.Show.Controller.showView.children.each (childView) =>
              childModel = childView.model
              childView.$el.removeClass("previewHighlight")
              childView.$el.removeClass("highlighted")
              childView.$el.removeClass("bioTriggerd")
              if childModel.get('name') in respnd
                if childView.$el.hasClass("highlighted")
                else if childView.$el.hasClass("bioTriggerd")
                else
                  childView.$el.addClass("previewHighlight")

        # respnd.forEach (name_res) =>
        #     if name_res not in output
        #       App.MainApp.Show.Controller.showView.collection.add(new App.Entity.ArtistSource({'name': name_res}))
              # thrn = childModel.get('name')
              # App.MainApp.Show.Controller.showView.filter(App.MainApp.Show.Controller.showView.collection.get(childModel), App.MainApp.Show.Controller.showView.collection)
              # @showView.children.remove(App.MainApp.Show.Controller.showView.children.findByModel(App.MainApp.Show.Controller.showView.collection.get(childModel)))
              # model_rem = App.MainApp.Show.Controller.showView.collection.get(childModel)
              # App.MainApp.Show.Controller.showView.collection.remove(App.MainApp.Show.Controller.showView.collection.get(childModel))
      updateView: (names) ->
        # @showView.destroy()
        # @showView.children.each (childview) =>
          # @showView.remove(childview)
        # @showView.collection.each (childModel) =>
        #   console.log childModel.get('name')
        #   childModel.destroy()

        
        # end of the block for refactoring
        updateCollection = $.ajax '/sourceByTarget/'+names,
              type: 'GET'
              dataType: 'json'
              error: (jqXHR, textStatus, errorThrown) ->
                # $('body').append "AJAX Error: #{textStatus}"
              success: (data, textStatus, jqXHR) =>
                ret = _.map data, (key, value) =>
                  # _.map key, (key, value) =>
                    # key
                  "name": key
                # return ret
        # this entire blok needs to be refoctored into a controller api method
        # console.log "what is this names:", names, App.NavApp.Show.Controller.showView.model.get('statelocation')
        console.log "#{App.NavApp.Show.Controller.showView.model.get('statebio')}"
        console.log "#{App.NavApp.Show.Controller.showView.model.get('statelist')}"
        
        $.when(updateCollection).done (respnd) =>
          output = []
          App.MainApp.Show.Controller.showView.collection.each (initmodels) =>
              output.push initmodels.get('name')
              # console.log "this is the out put which is a list of the list in the left", output
          # console.log "respnd when done", respnd
          # console.log "updateCollection when done", updateCollection
              
          App.MainApp.Show.Controller.showView.children.each (childView) =>
            childModel = childView.model
            if childModel.get('name') not in respnd
              # thrn = childModel.get('name')
              # App.MainApp.Show.Controller.showView.filter(App.MainApp.Show.Controller.showView.collection.get(childModel), App.MainApp.Show.Controller.showView.collection)
              # @showView.children.remove(App.MainApp.Show.Controller.showView.children.findByModel(App.MainApp.Show.Controller.showView.collection.get(childModel)))
              # model_rem = App.MainApp.Show.Controller.showView.collection.get(childModel)
              App.MainApp.Show.Controller.showView.collection.remove(App.MainApp.Show.Controller.showView.collection.get(childModel))
          respnd.forEach (name_res) =>
            if name_res not in output
              App.MainApp.Show.Controller.showView.collection.add(new App.Entity.ArtistSource({'name': name_res}))
                # App.MainApp.Show.Controller.showView.collection.addChild(newEnt)
          # index = respnd.indexOf childModel.get('name')
              # childModel.destroy()
          # App.MainApp.Show.Controller.showView.render()




            # else if childModel.get('name') in respnd
            #   index = respnd.indexOf childModel.get('name')
            #   output.push respnd.splice(index, 1) if index isnt -1
            #   respnd = output
            # respnd.forEach (eachres) =>
            #   newSmodel = new App.Entity.ArtistSource eachres 
            # # else
            #   respnd.forEach (eachres) =>
            #     newSmodel = new App.Entity.ArtistSource eachres
                # index = respnd.indexOf childModel.get('name')
              # output.push respnd.splice(index, 1) if index isnt -1
              # respnd = output[0] if respnd.length is 1
              # respnd = output
              # console.log "respnd", respnd
              # @showView.collection.remove(childModel)
                  # newSmodel = new App.Entity.ArtistSource mod
                # newCollection = new App.Entities.ArtistSourceSelectedCollection ret
                # newCollection.each (newModel) =>
                  # console.log "newModel", newModel
                  # console.log "newModel",newModel
                  # showItemView = new View.ShowView(model: newModel)
                  # @showView.collection.add(showItemView)
                  # console.log "!showView", @showView
                  # newViewBuilt = @showView.buildChildView(newModel, View.ShowView)
                  # @showView.children.add(newViewBuilt)
                # App.biosRegion.show(@showView)
                # @showView.render()
                # @showView.collection = newCollection
                # @showView.children.each (updatedItemView) =>
                #   updatedItemView.render()
                # @showView.render()
                # @updatedView = new View.ShowViews(collection: newCollection)
                # App.biosRegion.show @updatedView

        # @showView
        # @showView.render()
        # console.log "@ inside Show.Controller", @
          # @showView.children.each (childview) =>
            # console.log "childview", childview
            # console.log "@", @
            # @showView.remove(childview)
          
          # @showView = new View.ShowViews(collection: @showView.collection)
          # App.biosRegion.show @showView

        # @showView.children.each (view) =>
        #   console.log view
        # artistssourceC = new App.Entities.ArtistSourceCollection
        # artistssourceC.fetch 'success': (response) =>
        #   # console.log response
        #   # filterd = artistssourceC.where("name": arg)
        #   @showView = new View.ShowViews(collection: new App.Entities.ArtistSourceCollection(names))
        #   App.biosRegion.show @showView
      
      showView: ->
          
          # $.when(App.request "set:collection").done (collectionF) =>
            # console.log "App.ArtistSourceCollection", App.ArtistSourceCollection
          # console.log "ArtistModel", ArtistModel
            # console.log "before returning response", response
          stateModel =  new App.Entity.ArtistListState({'state': 'All artists'})
          artistssourceC = new App.Entities.ArtistSourceCollection
          artistssourceC.fetch 'success': (response) =>
            # console.log response
            # distinctedSources = artistssourceC.where()
            @creditView = new View.CreditView()
            App.bioRegion.show @creditView
            @showView = new View.ShowViews(
              collection: artistssourceC
              model: stateModel
            )

            App.biosRegion.show @showView
            # console.log "artistssourceC", artistssourceC
          # $.when(artistssourceC).done (res) =>
            # console.log "res", res
          # $.when(ArtistModel).done (response) =>
            # console.log "Model", ArtistModel
            # @showView = new View.ShowView(collection: ArtistModel)
            # App.mainRegion.show @showView
      		# getCollection = App.request "set:collection", 'artistssource'
      		# $.when(getCollection).done (artists) =>
        #     console.log "artists", artists
            

  App.MainApp.Show.Controller

