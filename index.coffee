express = require('express')
app = express()
router = express.Router()
config = require('./config')

spotify = require('./spotify')
soundcloud = require('./soundcloud')

# ==============================
# Set up routes
router
  .route('/')
  .get (req, res) -> 
    res.json message: 'Welcome'
    return

router
  .route('/search')
  .get spotify.search
router
  .route('/soundcloud')
  .get soundcloud.search

# ==============================
# Start server
app
  .use('/', router)
  .listen(config.port)
console.log('Started')