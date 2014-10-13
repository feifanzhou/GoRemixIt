https = require('https')

VARS = require('./vars')

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
  path = 'https://api.soundcloud.com/tracks.json?client_id=' + VARS.soundcloud_client_id + '&q=' + req.query.q
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
      items = if data.tracks then data.tracks.items else []
      response = items.map((item) ->
        artistName = ''
        artistName += (artist.name + ', ') for artist in item.artists
        artistName = artistName.slice(0, -2)
        return {
          id: item.id
          name: item.name
          popularity: item.popularity
          cover: item.album.images[2].url
          albumName: item.album.name
          artist: artistName
        }
      )
      spotifyResults = response
      respond(res)
    )
  )
  searchReq.on('error', (e) ->
    res.json message: 'Error: ' + e.message
    return
  )