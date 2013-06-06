         
bone = require '../../../bone.io'
browserPath = "#{__dirname}/../../bone.io-textsearch.js"

bone.module 'textsearch', browserPath, (options) ->
    search = options.search

    bone.io 'textsearch',
        inbound:
            search: search
        outbound:
            shortcuts: ['results']
