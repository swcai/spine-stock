var express = require('express')
var app = express.createServer()

// Reference
// http://expressjs.com/guide.html
// https://github.com/spadin/simple-express-static-server
// http://devcenter.heroku.com/articles/node-js

//CORS middleware
var allowCrossDomain = function(req, res, next) {
  res.header('Access-Control-Allow-Origin', config.allowedDomains);
  res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
}

// Configuration
app.configure(function(){
  app.use(express.static(__dirname + '/public'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(allowCrossDomain);
  // LESS Support
  //app.use(express.compiler({ src: __dirname + '/public', enable: ['less'] }));
  // Template-enabled html view (by jade)
  // http://stackoverflow.com/questions/4529586/render-basic-html-view-in-node-js-express
  //app.set('views', __dirname + '/app/views');
  //app.register('.html', require('jade'));

  //Error Handling
  app.use(express.logger());
  app.use(express.errorHandler({
    dumpExceptions: true,
    showStack: true
  }));

  //Setup the Route, you are almost done
  app.use(app.router);
});

app.get('/', function(req, res){
  //Apache-like static index.html (public/index.html)
  res.redirect("/index.html");
  //Or render from view
  //res.render("index.html")
});

//Heroku
var port = process.env.PORT || 80;
app.listen(port, function() {
  console.log("Listening on " + port);
});
