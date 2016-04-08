gulp     = require 'gulp'
plumber  = require 'gulp-plumber'
coffee   = require 'gulp-coffee'
notify   = require 'gulp-notify'

srcs =
    migrations: ['./migrations/*.coffee']
    app:        ['./app/**/*.coffee']

coffeePipeline = (src, dest) ->
    return ->
        dest = dest or './'
        gulp.src src
            .pipe plumber(errorHandler: notify.onError '<%= error.message %>')
            .pipe coffee { bare:false }
            .pipe gulp.dest dest

gulp.task 'coffee_migrations', coffeePipeline(srcs.migrations, './migrations')
gulp.task 'coffee_app',        coffeePipeline(srcs.app, './app')

gulp.task 'coffee', [
    'coffee_migrations'
    'coffee_app'
]

gulp.task 'default', ['coffee']
