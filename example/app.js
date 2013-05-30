
// Server setup
var express = require('express'),
    app = express(),
    server = require('http').createServer(app),
    io = require('socket.io').listen(server);

// Configure Bone.io
var bone = require('bone.io');
bone.io.set('config', {server: io});
require('../.');

bone.modules.textsearch({
    search: function(fragment, context) {
        // Handles the fragment searching logic
        var matches = []
        list.forEach(function(char) {
           regex = new RegExp(fragment.toLowerCase());
            if((regex).test(char.toLowerCase())) {
                matches.push(char);
            }
        });

        // Calling the results action on the adapter
        this.results(matches);
    }
});

// Make sure the client html gets served
app.use(express.static(__dirname));
app.get('/', function(req, res) {
    res.redirect('/client.html');
});

// Listen on a fun port
server.listen(7076);

