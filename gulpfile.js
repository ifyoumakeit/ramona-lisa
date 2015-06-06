var gulp            = require('gulp'),
    // this is an arbitrary object that loads all gulp plugins in package.json.
    $           = require("gulp-load-plugins")(),
    _           = require("lodash"),
    path        = require('path'),
    browserSync = require('browser-sync'),
    reload      = browserSync.reload,
    del         = require('del'),
    ghPages     = require('gulp-gh-pages'),
    browserifyHandlebars = require('browserify-handlebars');

console.log($);

gulp.task('browser-sync', function() {
  browserSync({
    server: {
      baseDir: "./dist"
    }
  });
});

gulp.task('compass', function() {
  return gulp.src('./src/stylesheets/**/*.scss')
    .pipe($.plumber())
    .pipe($.compass({
      css: 'dist/stylesheets',
      sass: 'src/stylesheets'
    }))
    .pipe($.autoprefixer({
        browsers: ['last 2 versions'],
        cascade: false
    }))
    .pipe($.minifyCss())
    .pipe(gulp.dest('dist/stylesheets'));
});

gulp.task('require', function() {
  return gulp.src('src/scripts/**/*', { read: false })
    .pipe($.plumber())
    .pipe($.browserify({
      debug: true,
      insertGlobals: false,
      transform: ['coffeeify'],
      extensions: ['.coffee']
    }))
    .pipe( $.rename({extname: '.js'}) )
    .pipe( $.uglify())
    .pipe( gulp.dest('dist/scripts') );
});

gulp.task('cson', function() {
  return gulp.src('src/data/**/*')
    .pipe($.plumber())
    .pipe($.cson())
    .pipe( $.rename({extname: '.json'}) )
    .pipe( gulp.dest('./dist/data') );
});

gulp.task('clean', function(cb) {
  del('./dist', cb);
});

gulp.task('images', function() {
  return gulp.src('./src/images/**/*')
    .pipe($.imagemin({
      progressive: true
    }))
    .pipe(gulp.dest('./dist/images'))
})

gulp.task('templates', function() {
  return gulp.src('src/*.jade')
    .pipe($.plumber())
    .pipe($.jade({
      data: {
        photos: _.sortByAll(require('./dist/data/photos.json'), 'title' ).reverse(),
        performances: require('./dist/data/performance.json')
      }
    }))
    .pipe( gulp.dest('dist/') )
});

gulp.task('build', ['compass', 'cson', 'require', 'templates', 'images']);

gulp.task('serve', ['build', 'browser-sync'], function () {
  gulp.watch('src/stylesheets/**/*.scss',['compass', reload]);
  gulp.watch('src/data/**/*.coffee',['cson', reload]);
  gulp.watch('src/scripts/**/*.coffee',['require', reload]);
  gulp.watch('src/images/**/*',['images', reload]);
  gulp.watch('src/**/*.jade',['templates', reload]);
});

gulp.task('default', ['serve']);

gulp.task('deploy', function() {
  return gulp.src('./dist/**/*')
    .pipe(ghPages());
});