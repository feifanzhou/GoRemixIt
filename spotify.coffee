https = require('https')
module.exports.search = (req, res) ->
  path = 'https://api.spotify.com/v1/search?type=artist,track&limit=5&q=' + req.query.q
  searchReq = https.get(path, (searchRes) ->
    # FIXME — Handle various status codes
    console.log('STATUS: ' + searchRes.statusCode)
    bodyChunks = []
    searchRes.on('data', (chunk) ->
      bodyChunks.push(chunk)
    ).on('end', ->
      # FIXME — Sort by popularity
      body = Buffer.concat(bodyChunks)
      data = JSON.parse(body)
      items = data.tracks.items
      ids = items.map((item) ->
        return item.id
      )
      res.setHeader('Content-Type', 'application/json')
      res.end(JSON.stringify(ids))
      return
    )
  )
  searchReq.on('error', (e) ->
    res.json message: 'Error: ' + e.message
    return
  )