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

			updateNavigationArtist: (navigation) ->
				console.log  "navigation", navigation
				# locState = App.NavApp.Show.Controller.showView.model.get('statelocation').replace "All locations >", ""
				App.NavApp.Show.Controller.showView.model.destroy()
				nav = new App.Entity.ArtistListState 
					statelist: navigation.attributes.statelist
					statelocation: navigation.attributes.statelocation
					statebio: navigation.attributes.statebio
				@showView = new View.ShowView(model: nav)
				App.navRegion.show @showView 

			updateNavigationLoc: (navigation) ->
				console.log  "navigation", navigation
				# locState = App.NavApp.Show.Controller.showView.model.get('statelocation').replace "All locations >", ""
				App.NavApp.Show.Controller.showView.model.destroy()
				nav = new App.Entity.ArtistListState 
					statelist: navigation.attributes.statelist
					statelocation: navigation.attributes.statelocation
					statebio: navigation.attributes.statebio
				@showView = new View.ShowView(model: nav)
				App.navRegion.show @showView

			updateNavigationBio: (navigation) ->
				App.NavApp.Show.Controller.showView.model.destroy()
				nav = new App.Entity.ArtistListState 
					statelist: navigation.attributes.statelist
					statelocation: navigation.attributes.statelocation
					statebio: navigation.attributes.statebio
				@showView = new View.ShowView(model: nav)
				App.navRegion.show @showView

			updateNavigation: (names) ->
				# if "#{App.NavApp.Show.Controller.showView.model.get('statelist')}" == "All artists"
		  #         location_text = "All locations"
		  #       else
		  #         location_text = "All locations > #{names}"
		  #       if App.NavApp.Show.Controller.showView.model.get('statelist') == 'All artists' 
		  #         navigation = new App.Entity.ArtistListState 
		  #           statelist: "All artists"
		  #           statelocation: "#{location_text}"
		  #           statebio: "#{App.NavApp.Show.Controller.showView.model.get('statebio')}"
		  #       else if App.NavApp.Show.Controller.showView.model.get('statelocation').replace /^\s+|\s+$/g, "" == 'All locations' and  App.NavApp.Show.Controller.showView.model.get('statelist') == 'All artists' + names 
		  #         App.NavApp.Show.Controller.showView.model.destroy()
		  #         navigation = new App.Entity.ArtistListState 
		  #           statelist: "All artists >"
		  #           statelocation: "#{location_text}"
		  #           statebio: "#{names}"
		        
		  #       navigation = new App.Entity.ArtistListState 
		  #         statelist: "All artists > "
		  #         statelocation: "#{location_text}"
		  #         statebio: "#{names}"
				# @showView = new View.ShowView(model: navigation)
				# App.navRegion.show @showView
			showModal: () ->
				# App.addRegions
				# 	modal: new ModalRegion()
				# @showModal = new View.ShowModal()
				# App.modal.show @showModal
	App.NavApp.Show.Controller

