
# Bone.io Textsearch

Get that nice "Google" style search, without the billion dollar investment.

## In the browser

```
```

## In node

```
// Setup the server
var app = require('express')();
    server = require('http').createServer();
    io = require('socket.io').listen(server);

// Configure bone.io
var bone = require('bone.io');
require('bone.io-textsearch');
bone.io.set('config', {server: io});

// Rockout with your cock out
bone.modules.textsearch(options);
```

You can supply the following `options`:

* `search` - Data route that receives two arguments `data`, and `context`.
* `inboundMiddleware` - Array of inbound bone.io middleware functions.
* `outboundMiddleware` - Array of outbound bone.io middleware functions.


