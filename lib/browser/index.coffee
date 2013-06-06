

bone.modules.textsearch = (options) ->
    options ?= {}
    module = {}
    module.IO = bone.io 'textsearch',
        inbound:
            middleware: options.inboundmiddleware
            results: (data, context) ->
                module.View(context.view.id).render data
        outbound:
            middleware: options.outboundMiddleware
            shortcuts: ['search']
    module.View = bone.view '[data-ui="textsearch"]',
        events:
            'focus': 'focus'
            'blur': 'blur'
            'keypress': 'keypress'
            'keyup': 'keyup'
            'keydown': 'keydown'
        defaults:
            menu: '<ul class="typeahead dropdown-menu"></ul>'
            item: '<li><a href="#"></a></li>'
            minLength: 1
            items: 8
        initialize: ->
            @options = $.extend {}, @defaults
            @$menu = $(@options.menu)
            @shown = false
            @$menu
                .on('click', $.proxy(@click, this))
                .on('mouseenter', 'li', $.proxy(this.mouseenter, this))
                .on('mouseleave', 'li', $.proxy(this.mouseleave, this))

        move: (event) ->
            return unless @shown
            switch event.keyCode
                when 9, 13, 27 # tab, enter, escape
                    event.preventDefault()
                when 38 # up arrow
                    event.preventDefault()
                    @prev()
                when 40 # down arrow
                    event.preventDefault()
                    @next()

        lookup: ->
            @lookupData = @query = @$el.val()
            if @options.lookup?
                @lookupData = @options.lookup()
                
            module.IO.search @lookupData, view: this

        keydown: (event) ->
            @suppressKeyPressRepeat = ~$.inArray(event.keyCode, [40,38,9,13,27])
            @move event
    
        keypress: (event) ->
            return if @supressKeyPressRepeat
            @move event

        keyup: (event) ->
            switch event.keyCode
                when 40,38,16,17,18 # up,down,shift,ctrl,alt
                    break
                when 9,13 #tab,enter
                    return unless @shown
                    @select()
                when 27
                    return unless @shown
                else
                    @lookup()
            event.stopPropagation()
            event.preventDefault()

        focus: (event) ->
            @focused = true

        blur: (event) ->
            @focused = false
            @hide() if not @mousedover and @shown
        
        click: (event) ->
            event.stopPropagation()
            event.preventDefault()
            @select()
            @$el.focus()
        
        mouseenter: (event) ->
            @mousedover = true
            @$menu.find('.active').removeClass 'active'
            $(event.currentTarget).addClass 'active'

        mouseleave: (event) ->
            @mousedover = false
            @hide() if not @focused and @shown
        
        show: ->
            pos = $.extend {}, @$el.position(),
                height: @$el[0].offsetHeight
            @$menu
                .insertAfter(@$el)
                .css({
                    top: pos.top + pos.height
                    left: pos.left
                })
                .show()
            @shown = true
            return this
        select: ->
            val = @$menu.find('.active').attr('data-value')
            @$el.val(val).change()
            @hide()
        hide: ->
            @$menu.hide()
            @shown = false
        highlighter: (item) ->
            query = @query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&")
            item.replace new RegExp("(" + query + ")", "ig"), ($1, match) ->
                "<strong>" + match + "</strong>"
        render: (items) ->
            items = items.slice 0, @options.items
            that = this
            items = $(items).map (i, item) =>
              i = $(@options.item).attr("data-value", item)
              i.find("a").html @highlighter(item)
              i[0]
            items.first().addClass "active"
            @$menu.html items
            this.show()
        next: (event) ->
            active = @$menu.find('.active').removeClass 'active'
            next = active.next()
            unless next.length
                next = $(@$menu.find('li')[0])
            next.addClass 'active'
        prev: (event) ->
            active = @$menu.find('.active').removeClass 'active'
            prev = active.prev()
            unless prev.length
                prev = @$menu.find('li').last()
            prev.addClass 'active'
        
    return module
