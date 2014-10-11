express = require('express')
app = express()
router = express.Router()
response_time = require('response-time')
config = require('./config')

search = require('./search')

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

# ==============================
# Start server
app
  .use('/', router)
  .use(response_time())
  .set('views', './views')
  .set('view engine', 'ejs')
  .listen(config.port)
console.log('Started')