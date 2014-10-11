express = require('express')
app = express()
router = express.Router()
response_time = require('response-time')
coffeeMiddleware = require('coffee-middleware')
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
  .use('/', router)
  .use(response_time())
  .use(coffeeMiddleware({
    src: __dirname + '/views/pages'
    compress: true
  }))
  .set('views', './views')
  .set('view engine', 'ejs')
  .listen(config.port)
console.log('Started')