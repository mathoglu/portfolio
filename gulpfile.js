var gulp = require('gulp');
var coffee = require('gulp-coffee');
var sass = require('gulp-sass');
var autoprefixer = require('gulp-autoprefixer');
var server = require('gulp-express');
var plumber = require('gulp-plumber');
var coffeelint = require('gulp-coffeelint');

gulp.task('server', function () {
    // Start the server at the beginning of the task 
    server.run(['bin/app.js']);
});

gulp.task('watch', function() {
    gulp.watch(['src/app/**/*.jade'], ['move']);
    gulp.watch(['src/styles/**/*.scss'], ['sass']);
    gulp.watch(['src/app/**/*.coffee'], ['coffee']);
});

gulp.task('coffee', function() {
    gulp.src('./src/app/*.coffee')
        .pipe(plumber())
        .pipe(coffeelint())
        .pipe(coffeelint.reporter())
        .pipe(coffee({bare: true}))
        .pipe(gulp.dest('./public/'));

    gulp.src('./src/server/app.coffee')
        .pipe(plumber())
        .pipe(coffeelint())
        .pipe(coffeelint.reporter())
        .pipe(coffee({bare: true}))
        .pipe(gulp.dest('./'));

    gulp.src('./src/server/**/*.coffee')
        .pipe(plumber())
        .pipe(coffeelint())
        .pipe(coffeelint.reporter())
        .pipe(coffee({bare: true}))
        .pipe(gulp.dest('./bin/'))
});

gulp.task('move', function() {

	gulp.src('./src/assets/font-awesome-4.3.0/**/*.*')
        .pipe(plumber())
		.pipe(gulp.dest('./public/assets/fa/'));

	gulp.src('./src/app/**/*.jade')
        .pipe(plumber())
		.pipe(gulp.dest('./bin/views/'));

    gulp.src('./src/content/*.json')
        .pipe(plumber())
        .pipe(gulp.dest('./bin/content/'));

	gulp.src('./src/assets/images/*')
        .pipe(plumber())
		.pipe(gulp.dest('./public/assets/images'));

    var bower = './bower_components/';
    gulp.src([bower + 'jquery/dist/jquery.min.js'])
        .pipe(plumber())
        .pipe(gulp.dest('./public/lib/'))
});

gulp.task('sass', function() {
  gulp.src('./src/styles/main.scss')
        .pipe(plumber())
        .pipe(sass())
        .pipe(autoprefixer())
        .pipe(gulp.dest('./public/'))
});

gulp.task('build', ['coffee', 'sass', 'move']);
gulp.task('serve', ['build', 'server', 'watch']);
gulp.task('prod', ['build','server']);