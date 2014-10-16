express = require('express')
app = express()
router = express.Router()
response_time = require('response-time')
coffeeMiddleware = require('coffee-middleware')
sass = require('node-sass')
config = require('./config')
vars = require('./vars')

soundcloud = require('./soundcloud')
spotify = require('./spotify')

# ==============================
# Set up routes
router
  .route('/')
  .get (req, res) -> 
    res.render('index', { soundcloud_client_id: vars.soundcloud_client_id })
    return

router
  .route('/soundcloud/search')
  .get soundcloud.search

router
  .route('/spotify/search')
  .get spotify.search
router
  .route('/spotify/top_tracks')
  .get spotify.topTracks

# ==============================
# Start server
app
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
  .use(express.static(__dirname + '/public'))
  .set('views', './views')
  .set('view engine', 'ejs')
  .listen(config.port)