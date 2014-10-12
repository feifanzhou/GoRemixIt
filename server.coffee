express = require('express')
app = express()
router = express.Router()
response_time = require('response-time')
coffeeMiddleware = require('coffee-middleware')
sass = require('node-sass')
config = require('./config')

search = require('./search')
spotify = require('./spotify')

# ==============================
# Set up routes
router
  .route('/')
  .get (req, res) -> 
    res.render('index')
    return

router
  .route('/search')
  .get search.search

router
  .route('/spotify/top_tracks')
  .get spotify.topTracks

# ==============================
# Start server
app
  .use(express.static(__dirname + '/public'))
  .use('/', router)
  .use(response_time())
  .use(coffeeMiddleware({
    src: __dirname + '/views/pages'
    compress: true
  }))
  .use(sass.middleware({
    src: __dirname + '/assets/stylesheets'
    dest: __dirname + '/public'
    debug: true
    outputStyle: 'nested'
  }))
  .set('views', './views')
  .set('view engine', 'ejs')
  .listen(config.port)