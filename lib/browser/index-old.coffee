
# Get the bone library
bone = undefined
if module?.exports?
    bone = require 'bone.io'
else
    bone = window.bone

$ = bone.$

bone.modules.typeahead = (options) ->
    adapter = options.adapter
    adapter ?= 'socket.io'

    socket = options.socket

    css = options.css
    css ?=
        input: 'input.search'
        results: 'ul.search-results'

    @io = bone.io 'typeahead',
        adapter: adapter
        options:
            socket: socket
        outbound: ['search']
        inbound:
            results: (data, context) ->
                @view.refresh listings

    events = {}
    events["keyup #{input}"] = 'search'

    @view = bone.view selector, bone.view css.container,
  
        # Events hash
        events: events

        # Refresh search results
        refresh: (listings) ->
    
            # Grab the listings box
            $listings = @$(css.results)
    
            # Empty the listings box
            $listings.html ""
    
            # Iterate through the new listings from the server
            $.each listings, (index, listing) ->
      
            # Add the listing to the list.
            $("<li>").appendTo($listings).html @highlight(listing)
  
        # Highlight individual entries
        highlight: (item) ->
            fragment = @fragment.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&")
            regex = new RegExp("(" + fragment + ")", "ig")
            item.replace regex, ($1, match) ->
                "<strong>" + match + "</strong>"

        # Triggers a search
        search: (event) ->
            @fragment = @$("input.search").val()
            return @refresh([])  if fragment.length is 0
            @io.search fragment
    
    return this
