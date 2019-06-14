time = require 'time-grunt'
jit = require 'jit-grunt'
autoprefixer = require 'autoprefixer'
cssVariables = require 'postcss-css-variables'
calc = require 'postcss-calc'

config =
    responsive_images:
        options:
            engine: 'im'
            newFilesOnly: true
        'small':
            options:
                sizes: [{rename: false, width: 400}]
            files: [
                    expand: true
                    cwd: 'raw-images'
                    src: '**/*.{jpg,png}'
                    dest: 'public/images/small'
            ]
        'large':
            options:
                sizes: [{rename: false, width: 1000}]
            files: [
                    expand: true
                    cwd: 'raw-images'
                    src: '**/*.{jpg,png}'
                    dest: 'public/images/large'
            ]

    exec:
        'hexo-compile': 'hexo generate'

    'gh-pages':
        production:
            options:
                base: 'public'
            src: '**/*'
        stage:
            options:
                base: 'public'
                repo: 'git@github.com:dominiclooser/todo.git'
            src: '**/*'

    postcss:
        options:
            processors: [autoprefixer({browers: 'last 2 versions'}), cssVariables, calc]
        main:
            src: 'www/styles/styles.css'

    copy:
        'production':
            src: 'cnames/production'
            dest: 'public/CNAME'
        'stage':
            src: 'cnames/stage'
            dest: 'public/CNAME'

    watch:
        options:
            livereload: true
        images:
            files: ['raw-images/**/*']
            tasks: ['responsive_images']
        all:
            files: ['**/*.*']
            tasks: []

module.exports = (grunt) ->
    grunt.initConfig config
    time grunt
    jit grunt
    grunt.registerTask 'default', ['watch'] 
    grunt.registerTask 'compile', ['exec:hexo-compile', 'postcss']
    grunt.registerTask 'deploy', ['compile','copy:production', 'gh-pages:production']
    grunt.registerTask 'stage', ['compile','copy:stage', 'gh-pages:stage']
