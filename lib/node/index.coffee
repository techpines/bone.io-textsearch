         

bone = require 'bone.io'

console.log 'heyho'
bone.modules.textsearch = (options) ->
    server = options.server
    search = options.search

    bone.io 'typeahead',
        inbound:
            search: search
        outbound: ['results']


