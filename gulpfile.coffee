gulp       = require 'gulp'
plumber    = require 'gulp-plumber'
coffee     = require 'gulp-coffee'
notify     = require 'gulp-notify'
sourcemaps = require 'gulp-sourcemaps'

srcs =
    migrations: ['./migrations/*.coffee']
    app:        ['./app/**/*.coffee']
    www:        ['./www/**/*.coffee']

coffeePipeline = (src, dest) ->
    return ->
        dest = dest or './'
        gulp.src src
            .pipe sourcemaps.init()
            .pipe plumber(errorHandler: notify.onError '<%= error.message %>')
            .pipe coffee { bare:false }
            .pipe sourcemaps.write()
            .pipe gulp.dest dest

gulp.task 'coffee-migrations', coffeePipeline(srcs.migrations, './migrations')
gulp.task 'coffee-app',        coffeePipeline(srcs.app,        './app')
gulp.task 'coffee-www',        coffeePipeline(srcs.www,        './www')


gulp.task 'coffee', [
    'coffee-migrations'
    'coffee-app'
    'coffee-www'
]

gulp.task 'watch-app',['coffee-app'], ->
    gulp.watch srcs.app, ['coffee-app']

gulp.task 'default', ['coffee']
