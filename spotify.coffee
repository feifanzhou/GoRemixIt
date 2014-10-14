http = require('http')
https = require('https')

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
      trackData = tracks.map((track) -> 
        return {
          artwork: track.artwork_url
          name: track.track_name
          artist: track.artist_name
        }
      )
      res.setHeader('Content-Type', 'application/json')
      res.json(trackData)
    )
  ).on('error', (e) ->
    res.json message: 'Error: ' + e.message
    return
  )
module.exports.search = (req, res) ->
  path = 'https://api.spotify.com/v1/search?type=artist,track&limit=5&q=' + req.query.q
  searchReq = https.get(path, (searchRes) ->
    # FIXME — Handle various status codes
    console.log('Spotify STATUS: ' + searchRes.statusCode)
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
          cover300: item.album.images[1].url
          cover64: item.album.images[2].url
          albumName: item.album.name
          albumURL: item.album.external_urls.spotify
          artist: artistName
          artistURL: item.artists[0].external_urls.spotify
        }
      )
      res.setHeader('Content-Type', 'application/json')
      res.json(response)
    )
  )
  searchReq.on('error', (e) ->
    res.json message: 'Error: ' + e.message
    return
  )