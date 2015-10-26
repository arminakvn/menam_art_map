define ["js/app","tpl!js/apps/bio_app/show/templates/show_view.tpl", "tpl!js/apps/bio_app/show/templates/show_views.tpl"], (App,showTpl, showsTpl) ->
  App.module "BioApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.ShowView = Marionette.ItemView.extend(
      template: showTpl
      className: ->
        if @model.attributes.name in App.list
          return 'bioItem location'
        else
          return 'bioItem'
      tagName: 'span'
      id: 'bioItem'
      # el: 'span'
      $el: $("#bioItem")
      ui: 
        'elems': 'span'
      events:
        'mouseover @ui.elems': 'mouseoverElems'
        'mouseout @ui.elems': 'mouseoutElems'
        'click @ui.elems': 'mouseclickElems'
      mouseoverElems: (e) ->
        # console.log "App.DistinctLinkCollection.models", App.MapApp.Show.Controller.showView.list
        # console.log "@$el", @$el[0].textContent
        @$el.css('cursor','pointer')
        if @$el.hasClass("location")          
          @$el.addClass('highlighted')
          # App.execute("highlightNode", e.target.id)
          list = App.BioApp.Show.Controller.listLevelOne(@$el[0].textContent)
          # $.when(App.list).done (respnd) =>
          #     respnd
          App.MainApp.Show.Controller.highlightArtistsby(list)
          
          # App.execute("highlightNode", e.target.id)
          # highlightArtistsby
      onBeforeRender: ->
        if @model.attributes.name in App.MapApp.Show.Controller.showView.list
            @$el.addClass 'bioItem location'
            # console.log "@el", @$el
          else
            @$el.addClass 'bioItem'
          return
        @$el.animate({
          opacity: 1
        }, 500)
      onBeforeClose: ->
        @$el.animate({
          opacity: 0
        }, 750)
      mouseoutElems: (e) ->
        @$el.css('cursor','default')
        @$el.removeClass('highlighted')
        App.MainApp.Show.Controller.resetHighlightArtistsby()

      mouseclickElems: (e) ->
        if @model.attributes.name in App.MapApp.Show.Controller.showView.list
          App.MainApp.Show.Controller.updateView(@model.attributes.name)
          App.MapApp.Show.Controller.resetMapHighlights()
          App.MapApp.Show.Controller.previewByLocation(@$el[0].textContent)
          navigation = new App.Entity.Navigation 
            statelist: "All artists > #{@$el[0].textContent}"
            statelocation: "All locations > #{@$el[0].textContent}"
          App.NavApp.Show.Controller.updateNavigationLoc(navigation)  
          setTimeout (=>
            App.execute("highlightPlace", @$el[0].textContent)
            return
          ), 3000

      onShow: ->
        timedText = ->
          setTimeout myTimeout1, 200
          return
        myTimeout1 = =>
          if @model.attributes.name in App.list
            @$el.addClass 'bioItem location'
            # console.log "@el", @$el
          else
            @$el.addClass 'bioItem'
          return
    )
    View.ShowViews = Marionette.CompositeView.extend(
      itemView: View.ShowView
      template: showsTpl
      # tagName: 'div'
      # itemViewContainer: 'div'
      className: 'bioView'
      # id:"bioview"
      onBeforeRender: ->
        @$el.animate({
          opacity: 1
        }, 500)
      onBeforeClose: ->
        @$el.animate({
          opacity: 0
        }, 750)
        @children.each (childView) =>
          childModel = childView.model
          if childModel.attributes.name in App.MapApp.Show.Controller.showView.list
            childView.$el.addClass 'bioItem location'
            # console.log "@el", @$el
          else
            childView.$el.addClass 'bioItem'
          return
      onAfterRender: ->
        @children.each (childView) =>
          childModel = childView.model
          if childModel.attributes.name in App.MapApp.Show.Controller.showView.list
            childView.$el.addClass 'bioItem location'
            # console.log "@el", @$el
          else
            childView.$el.addClass 'bioItem'
          return
      onShow: ->
        console.log App
        @children.each (childView) =>
          childModel = childView.model
          if childModel.attributes.name in App.list
            childView.$el.addClass 'bioItem location'
            # console.log "@el", @$el
          else
            childView.$el.addClass 'bioItem'
          return


    )
  App.BioApp.View