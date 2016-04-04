gulp     = require 'gulp'
plumber  = require 'gulp-plumber'
coffee   = require 'gulp-coffee'
uglify   = require 'gulp-uglify'
notify   = require 'gulp-notify'

src =
    coffee: ['./**/*.coffee', '!./gulpfile.coffee']

gulp.task 'coffee', ()->
    gulp.src src['coffee']
        .pipe plumber(errorHandler: notify.onError '<%= error.message %>')
        .pipe coffee { bare:false }
        .pipe uglify()
        .pipe gulp.dest './'

gulp.task 'watch', ()->
    gulp.watch src.coffee, ['coffee']

gulp.task 'default', ['coffee']
gulp.task 'dev', ['coffee','watch']
