
module.exports = (grunt) ->
    
    # Project configuration.
    grunt.initConfig
        pkg: grunt.file.readJSON "./package.json"
        coffee: compileJoined:
            options: bare: true
            files:
                "bone.io-textsearch.js": [
                    "lib/browser/index.coffee"
                ]
        uglify:
            my_target:
                files:
                    "bone.io-textsearch.min.js": ["bone.io-textsearch.js"]

        watch:
            files: ["lib/browser/*.coffee"]
            tasks: ["default"]

    
    # These plugins provide necessary tasks
    grunt.loadNpmTasks "grunt-contrib-coffee"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-contrib-watch"
    
    # Default task
    grunt.registerTask "default", ["coffee", "uglify"]

    # Watch task
    grunt.registerTask "dev", ["coffee", "uglify", "watch"]

    
