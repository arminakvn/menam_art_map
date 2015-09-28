define ["js/app", "tpl!js/apps/nav_app/show/templates/show_view.tpl"], (App, showTpl) ->
  App.module "NavApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.ShowView = Marionette.Layout.extend(
      template: showTpl
      id:"nav"
      tagName:"div"
      class: "artistsList list-navigator"
      ui:
        'div':'div'
      events:
        'click @ui.div' : 'navigate'
        'mouseover @ui.div' : 'mouseoverNav'
        'mouseout @ui.div' : 'mouseoutNav'

      navigate: (e) ->
        console.log "nav @model", @model
        App.MainApp.Show.Controller.updateView('all')
        App.MapApp.Show.Controller.resetMapHighlights()
      # onDomRefresh:->
      #   @width = @el.clientWidth
      #   @height = @el.clientHeight
      mouseoverNav: (e) ->
        $(e.target).css('cursor','pointer')
      mouseoutNav: (e) ->
        $(e.target).css('cursor','default')
      initialize: ->
        # orgbysourceartist
      onShow: ->
        console.log "@models", @model
    )
  App.NavApp.View