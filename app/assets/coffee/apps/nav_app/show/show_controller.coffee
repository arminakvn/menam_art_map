define ["js/app", "js/apps/nav_app/show/show_view"], (App, View) ->
	App.Entity.Navigation = Backbone.Model.extend()
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
	App.module "NavApp.Show", (Show, App, Backbone, Marionette, $, _) ->
		Show.Controller =
			showNavigation: () ->
				navigation = new App.Entity.Navigation 
					statelist: "All artists"
					statelocation: "All locations"
					statebio: ""
				@showView = new View.ShowView(model: navigation)

				# console.log "@showView",@showView
				# App.modal.getEl("modal")
				App.navRegion.show @showView
				# $modalEl = $("#modal")
				# $modalEl.html(view.el)
				# $modalEl.modal()
			updateNavigation: (navigation) ->
				@showView = new View.ShowView(model: navigation)
				App.navRegion.show @showView
			showModal: () ->
				App.addRegions
					modal: new ModalRegion()
				@showModal = new View.ShowModal()
				App.modal.show @showModal
	App.NavApp.Show.Controller

