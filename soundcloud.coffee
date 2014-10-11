# soundcloud = require('soundcloud-node')
# client = new soundcloud('621df22484a042a1d52a8f74513c2842', '005466d958d925dfb49bead2f50754db', 'http://goremix.it')
https = require('https')

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
      res.setHeader('Content-Type', 'application/json')
      res.end(JSON.stringify(ids))
      return
    )
  )
  searchReq.on('error', (e) ->
    res.json message: 'Error: ' + e.message
    return
  )