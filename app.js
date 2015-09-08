var app, bodyParser, cookieParser, debug, express, favicon, logger, path, routes, server;

express = require('express');

path = require('path');

favicon = require('serve-favicon');

logger = require('morgan');

cookieParser = require('cookie-parser');

bodyParser = require('body-parser');

app = express();

app.set('views', path.join(__dirname, 'views'));

app.set('view engine', 'jade');

routes = require('./routes/index');

app.use(logger('dev'));

app.use(bodyParser.json());

app.use(bodyParser.urlencoded({
  extended: false
}));

app.use(cookieParser());

app.use(express["static"](path.join(__dirname, '../public')));

app.use('/', routes);

app.use(function(req, res, next) {
  var err;
  err = new Error('Not Found');
  err.status = 404;
  next(err);
});

if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('error', {
      message: err.message,
      error: err
    });
  });
}

app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  res.render('error', {
    message: err.message,
    error: {}
  });
});

debug = require('debug')('mafffs');

app.set('port', process.env.PORT || 3000);

server = app.listen(app.get('port'), function() {
  return debug('Express server listening on port ' + server.address().port);
});

module.exports = app;
