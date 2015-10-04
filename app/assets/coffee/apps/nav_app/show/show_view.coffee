define ["js/app", "tpl!js/apps/nav_app/show/templates/show_view.tpl", "tpl!js/apps/nav_app/show/templates/show_modal.tpl"], (App, showTpl, modalTpl) ->
  ModalRegion = Backbone.Marionette.Region.extend(
    el: '#modal'
    constructor: ->
      _.bindAll this
      Backbone.Marionette.Region::constructor.apply this, arguments
      @on 'view:show', @showModal, this
      return
    getEl: (selector) ->
      $el = $(selector)
      $el.on 'hidden', @close
      $el
    showModal: (view) ->
      view.on 'close', @hideModal, this
      @$el.modal 'show'
      return
    hideModal: ->
      @$el.modal 'hide'
      return
  )
  App.module "NavApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.ShowView = Marionette.Layout.extend(
      template: showTpl
      id:"nav"
      tagName:"div"
      class: "artistsList list-navigator"
      ui:
        'div':'div'
      events:
        'click #statelist' : 'navigate'
        'click #statelocation' : 'locations'
        'mouseover @ui.div' : 'mouseoverNav'
        'mouseout @ui.div' : 'mouseoutNav'

      navigate: (e) ->
        # console.log "nav @model", @model
        # if @model.attributes.statelocation != 'All locations'
        App.MainApp.Show.Controller.updateView('all')
        App.MapApp.Show.Controller.resetMapHighlights()
      # onDomRefresh:->
      #   @width = @el.clientWidth
      #   @height = @el.clientHeight
      mouseoverNav: (e) ->
        $(e.target).css('cursor','pointer')
      mouseoutNav: (e) ->
        $(e.target).css('cursor','default')
      locations: (e) ->
        App.navigate "/", trigger: true
        # console.log "@model.attributes.statelocation.replace('All locations > ', "")", @model.attributes.statelocation.replace('All locations > ', "")
        # if @model.attributes.statelocation != 'All locations'
          # App.MapApp.Show.Controller.previewByLocation(@model.attributes.statelocation.replace('All locations > ', ""))
      initialize: ->

      onShow: ->

        # $('input[name="my-checkbox"]').bootstrapSwitch('handleWidth', $("#statebio"))
    )
    View.ShowModal = Marionette.Layout.extend(
      template: modalTpl
      id:"modal"
      # tagName:"div"
      ui:
        'modal':'div'
      events:
        # 'click @ui.div' : 'navigate'
        'mouseover @ui.modal' : 'mouseoverModal'
        'mouseout @ui.modal' : 'mouseoutModal'

      # navigate: (e) ->
        # console.log "nav @model", @model
        # App.MainApp.Show.Controller.updateView('all')
        # App.MapApp.Show.Controller.resetMapHighlights()
      # onDomRefresh:->
      #   @width = @el.clientWidth
      #   @height = @el.clientHeight
      mouseoverModal: (e) ->
        $(e.target).css('cursor','pointer')
      mouseoutModal: (e) ->
        $(e.target).css('cursor','default')
      initialize: ->
        # orgbysourceartist
      onShow: ->
        # console.log "@models", @model
    )
  App.NavApp.View