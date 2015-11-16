define ["js/app", "js/apps/org_app/show/show_view"], (App, View) ->
	App.module "OrgApp.Show", (Show, App, Backbone, Marionette, $, _) ->
		App.Entities.Artist = Backbone.Model.extend()
		App.Entities.ArtistCollection = Backbone.Collection.extend(
	      initialize: (url) ->
	      	console.log "url"
	      	@param = url
	      	@on 'request', ->
	          # MfiaClient.app.trigger 'loading'
	          console.log "loading"
	          return
	        @on 'sync', ->
	          # MfiaClient.app.trigger 'loaded'
	          console.log "loaded"
	          return
	        return
	      
	      url: -> 
	      	console.log "@param", @param
	      	return "/artistsbysource/"+@param.param
	      
	      getLevelData: (res) ->
	      	updateCollection = $.ajax '/artstsby/'+res.target.replace /^\s+|\s+$/g, "",
	                type: 'GET'
	                dataType: 'json'
	                error: (jqXHR, textStatus, errorThrown) ->
	                # $('body').append "AJAX Error: #{textStatus}"
	                success: (data, textStatus, jqXHR) =>
	                    # console.log "data!!", data
	                    # ret = _.map data, (key, value) =>
	                    #     "target": key.target
	                    return data
       #      $.when(updateCollection).done (respnd) =>
       #          return respnd
	      # parse: (response) ->
	        @repona = []
	        $.when(response).done (res)=>
	            # response.forEach (res) =>
	            #     $.when(res).done (resB)=>
	            #         eachRes = @getLevelData(resB)
	            #         $.when(eachRes).done (Res)=>
	            #             repona.push(Res)
	            
	        # data = _.map response, (key, value) =>
	        #   # _.map key, (key, value) =>
	        #     # key
	        #   "name": key
	        # data
	            console.log "repona", @repona
	            return @repona
	    )
		Show.Controller =
			showTwoLevelOrganization: (resB) =>
				
	                # $.when(resB).done (resB)=>	               
	                #     # showOrganization(resB)
	                #     console.log "showViwqssss", @Controller.showView, resB.attributes.target.replace /^\s+|\s+$/g, ""
	                #     @Controller.showView.svg.selectAll('.link').data(t_links)
	                    



	                    # get the level two data for them then
	                   


	                    # eachRes = @getLevelData(resB)
	                    # $.when(eachRes).done (Res)=>
	                        
	                    #     @Controller.Show.draw()
	                    #     repona.push(Res)
			showOrganization: (ssource) ->
				artistss = new App.Entities.ArtistCollection(param:ssource)
				artistss.fetch 'success': (response) =>
		            @showView = new View.ShowView(collection: response)
		            
		            # response.forEach (res) =>
		            # 	@showTwoLevelOrganization(res)
		            App.mainRegion.show @showView
				
			
			highlightNodesBy: (sourceNode) ->
		        @_links.forEach (link) => 
		            if link.source.name == sourceNode.name
		              App.OrgApp.View.vis.selectAll("circle").filter((d, i) =>
		                d.name == link.target.name
		                # selectedNodes.push 'lat': +d.lat, 'long': +d.long if d.name == link.target.name
		              ).transition().duration(100
		              ).style("opacity", 1
		              ).attr("r", 10
		              ).style("fill", (d) =>
		                return @color(d.group)# @color(sourceNode.id)
		              ).style("stroke", (d) =>
		                return  @color(d.group)# @color(sourceNode.id)
		              ).style("stroke-width", 4
		              ).transition().duration(900
		              ).style("opacity", 1
		              ).attr("r", 20
		              ).style("stroke", (d) =>
		                return  @color(d.group) #@color(sourceNode.id)
		              # ).style("fill", (d) =>
		              #   return "none"
		              ).style("stroke-width", 1
		              ).transition().delay(50).duration(200
		              ).attr("r", (d) ->
		                if d.group == 2
		                  return Math.sqrt(d.value) * 20
		              ).style("stroke", (d) =>
		                return @color(d.group)# @color(sourceNode.id)
		              ).style("fill", (d) =>
		                return @color(d.group)#@color(sourceNode.id)
		              ).style("stroke-width", 0
		              )
		              App.OrgApp.View.vis.selectAll("text.nodetext").filter((d, i) =>
		                d.name == link.target.name
		              ).transition().duration(600).style("opacity", 1)

		              return
		            return
		        return
			resetHighlightNodesBy: ->
				@vis.selectAll("circle"
				).transition().duration(500
				).style("opacity", 0.6
				).attr("r", (d) ->
					if d.group == 2
		            	return Math.sqrt(d.value) * 2
					else 
						return 2
				).style("stroke-width", 1)
				@vis.selectAll("text.nodetext"
				).transition().duration(500
				).style("opacity", 0)
	App.OrgApp.Show.Controller

