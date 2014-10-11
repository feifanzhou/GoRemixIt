http = require('http')

VARS = require('./vars')

module.exports.topTracks = (req, res) ->
  path = 'http://charts.spotify.com/api/tracks/most_streamed/global/daily/latest'
  topReq = http.get(path, (topRes) ->
    bodyChunks = []
    topRes.on('data', (chunk) ->
      bodyChunks.push(chunk)
    ).on('end', ->
      # FIXME — Sort by popularity
      body = Buffer.concat(bodyChunks)
      data = JSON.parse(body)
      tracks = data.tracks
      artwork = tracks.map((track) -> return track.artwork_url)
      res.setHeader('Content-Type', 'application/json')
      res.end(JSON.stringify(artwork))
    )
  ).on('error', (e) ->
    res.json message: 'Error: ' + e.message
    return
  )