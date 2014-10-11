https = require('https')

spotifyResults = []
soundcloudResults = []

respond = (res) ->
  return if spotifyResults.length == 0 || soundcloudResults.length == 0
  res.setHeader('Content-Type', 'application/json')
  obj = {
    spotify: spotifyResults
    soundcloud: soundcloudResults
  }
  res.end(JSON.stringify(obj))
  spotifyResults = []
  soundcloudResults = []
  return

module.exports.search = (req, res) ->
  path = 'https://api.soundcloud.com/tracks.json?client_id=621df22484a042a1d52a8f74513c2842&q=' + req.query.q
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
      ids = data.map((track) ->
        return track.id
      )
      soundcloudResults = ids
      respond(res)
    )
  )
  searchReq.on('error', (e) ->
    res.json message: 'Error: ' + e.message
    return
  )
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
      spotifyResults = ids
      respond(res)
    )
  )
  searchReq.on('error', (e) ->
    res.json message: 'Error: ' + e.message
    return
  )