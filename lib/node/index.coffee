         
bone = require 'bone.io'
browserPath = "#{__dirname}/../../bone.io-textsearch.js"

bone.module 'textsearch', browserPath, (options) ->
    search = options.search

    bone.io 'textsearch',
        inbound:
            middleware: options.inboundMiddleware
            search: search
        outbound:
            middleware: options.outboundMiddleware
            shortcuts: ['results']
