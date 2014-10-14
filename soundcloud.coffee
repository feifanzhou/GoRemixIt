https = require('https')

VARS = require('./vars')

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
      sounds = data.map((track) ->
        return {
          id: track.id
          name: track.title
          artist: track.user.username
          link: track.permalink_url
          cover: track.artwork_url
          playCount: track.playback_count
        }
      )
      res.setHeader('Content-Type', 'application/json')
      res.json(sounds)
    )
  )
  searchReq.on('error', (e) ->
    res.json message: 'Error: ' + e.message
    return
  )