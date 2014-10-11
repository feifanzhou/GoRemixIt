express = require('express')
app = express()
router = express.Router()
config = require('./config')

spotify = require('./spotify')

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

# ==============================
# Start server
app
  .use('/', router)
  .listen(config.port)
console.log('Started')