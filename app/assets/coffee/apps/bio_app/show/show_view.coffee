define ["js/app","tpl!js/apps/bio_app/show/templates/show_view.tpl", "tpl!js/apps/bio_app/show/templates/show_views.tpl"], (App,showTpl, showsTpl) ->
  App.module "BioApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.ShowView = Marionette.ItemView.extend(
      template: showTpl
      className: ->
        if @model.attributes.name in App.MapApp.Show.Controller.showView.list
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
        # console.log "@$el", @$el[0].textContent
        @$el.css('cursor','pointer')
        if @$el.hasClass("location")          
          @$el.addClass('highlighted')
          list = App.BioApp.Show.Controller.listLevelOne(@$el[0].textContent)
          $.when(list).done (respnd) =>
              console.log "list", respnd
              respnd
              App.MainApp.Show.Controller.highlightArtistsby(list)
          # App.MapApp.Show.Controller.previewByLocation(@$el[0].textContent)
          # highlightArtistsby

      mouseoutElems: (e) ->
        @$el.css('cursor','default')
        @$el.removeClass('highlighted')
        App.MainApp.Show.Controller.resetHighlightArtistsby()

      mouseclickElems: (e) ->
        if @model.attributes.name in App.MapApp.Show.Controller.showView.list
          App.MainApp.Show.Controller.updateView(@model.attributes.name)
          App.MapApp.Show.Controller.resetMapHighlights()
      onShow: ->
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
      onShow: ->


    )
  App.BioApp.View