define ["js/app", "tpl!js/apps/main_app/show/templates/show_view.tpl"], (App, showTpl) ->
  App.module "MainApp.View", (View, App, Backbone, Marionette, $, _) ->
    View.ShowView = Marionette.ItemView.extend(
    	template: showTpl
    	id: 'bios'
    	$el: $('#bios')
    	ui: 'name': '#bio-list'
    	initialize: ->
    		

    	onShow: ->
    		$(document).ready =>
			    			@data = _.map App.ArtistSourceCollection.models, (key, value) =>
			      			_.map key.attributes, (key, value) =>
			      				value
    			# require ["js/entities/artist_source"], =>
    				# $.ajax '/artistssource',
    					# type: 'GET'
    					# dataType: 'json'
    					# error: (jqXHR, textStatus, errorThrown) ->
    						# $('body').append "AJAX Error: #{textStatus}"
    					# success: (data, textStatus, jqXHR) ->
    						# App.request "set:source:artist", data
			    			biosRegion = $("#bios-region")
			    			$el = biosRegion
			    			_textDomEl = L.DomUtil.create('div', 'container paratext-info')
			    			_el = L.DomUtil.create('svg', 'svg')
			    			biosRegion.append _textDomEl
			    			L.DomUtil.enableTextSelection(_textDomEl)  
			    			_textDomObj = $(L.DomUtil.get(_textDomEl))
			    			inWidth = $el[0].clientWidth/5
			    			_textDomObj.css('width', $el[0].clientWidth)
			    			_textDomObj.css('height', "970")
			    			_textDomObj.css('background-color', 'none')
			    			_textDomObj.css('overflow', 'auto')
			    			L.DomUtil.setOpacity(L.DomUtil.get(_textDomEl), .8)
			    			color = d3.scale.category10()
			    			_d3text = d3.select(".paratext-info")
					        .append("ul"
					        ).style("list-style-type", "none"
					        ).style("padding-left", "0px"
					        ).style('overflow', 'auto'
					        ).attr("id", "bios-list")
					        .attr("width", $el[0].clientWidth)
					        .attr("height", $el[0].clientHeight)
					        @_d3li = _d3text
					        .selectAll("li")
					        .data(@data)
					        .enter()
					        .append("li")
					        @_d3li.style("font-family", "Gill Sans").style("font-size", "16px")
					        .style("line-height", "1")
					        .style("border", "0px solid black")
					        .style("margin-top", "20px")
					        .style("padding-right", "20px")
					        .style("padding-left", "40px")
					        .attr("id", (d, i) =>
					            # artistBios.push {'name' :d.name, 'id': i}
					            return "line-#{i}" 
					        ).on("mouseover", (d) ->
					          $(this).css('cursor','pointer')
					        ).on("click", (d,i) ->
					          L.DomEvent.disableClickPropagation(this) 
					          d3.select(this).transition().duration(0).style("color", "black").style("background-color", (d, i) ->
					            "white"
					          ).style "opacity", 1
					          d3.select(this).transition().duration(1000).style("color", "rgb(72,72,72)").style("background-color", (d, i) =>
					            id = d3.select(this).attr("id").replace("line-", "")
					            return color(1) # color(id)
					          ).style("opacity", 1)
					          
					          return
					        ).append("text").text((d,i) =>
					            @_leafletli = L.DomUtil.get("line-#{i}")
					            timeout = undefined
					            L.DomEvent.addListener @_leafletli, 'click', (e) =>
					              d3.selectAll(@_d3li[0]).style("color", "black").style("background-color", "white"
					              ).style "opacity", 1
					              # App.execute("resetHighlightNode")
					              timeout = 0
					              timeout = setTimeout(->
					                # 
					                if timeout isnt 0 
					                  timeout = 0
					                  App.execute("highlightNode", d)
					                  console.log "executing showBio"
					                  # App.MapApp.Show.Controller.showBio(d)
					                  App.execute("showBio", d)
					              , 600)
					              return 
					            , ->

					              return
					              e.stopPropagation()
					            d
					        ).style("font-family", "Gill Sans").style("font-size", "14px").style("color", "black").transition().duration(1).delay(1).style("opacity", 1)
    )

  App.MainApp.View