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
      ui: 
        'elems': 'span'
      events:
        'mouseover @ui.elems': 'mouseoverElems'
        'mouseout @ui.elems': 'mouseoutElems'
      mouseoverElems: (e) ->
        $(e.target).css('cursor','pointer')
        $(e.target).addClass('highlighted')

      mouseoutElems: (e) ->
        $(e.target).css('cursor','default')
        $(e.target).removeClass('highlighted')
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