
# Bone.io Textsearch

Get that nice "Google" style search, without the billion dollar investment.

## In the browser

In the head do this:

```html
<script src="/bone.io-textsearch.js"></script>
<script>
  bone.modules.TextSearch = bone.modules.textsearch(options)
</script>
```

You can pass in the following options:

* `selector` - The selector that designates textsearch boxes.
* `inboundMiddleware` - Inbound bone.io middleware.
* `outboundMiddleware` - Outbound bone.io middleware.


Then create as many textsearch boxes as you want in your html like this:

```html
<input type="text", data-ui="textsearch" />
```

## In node

```js
require('bone.io-textsearch');

// Rockout with your cock out
bone.modules.textsearch(options);
```

You can supply the following `options`:

* `search` - Data route that receives two arguments `data`, and `context`.
* `inboundMiddleware` - Array of inbound bone.io middleware functions.
* `outboundMiddleware` - Array of outbound bone.io middleware functions.


