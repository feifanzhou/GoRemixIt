Navbar = React.createClass({
  render: ->
    React.DOM.header
      id: 'navbar'
      children: [
        React.DOM.section
          id: 'headerLogo'
          children: [
            React.DOM.i
              className: 'fa fa-plus HeaderIcon'
            React.DOM.h1
              className: 'HeaderBody'
              children: 'Remixes'
          ]
        React.DOM.section
          id: 'headerSearch'
          children: 
            React.DOM.button
              className: 'InvisibleButton'
              onClick: if @props.isSearching then @props.endSearch else @props.startSearch
              children: [
                React.DOM.i
                  className: 'fa fa-search HeaderIcon'
                React.DOM.h1
                  className: 'HeaderBody'
                  children: 'Search'
              ]
        React.DOM.section
          id: 'headerPlayback'
          children: [
            React.DOM.section
              id: 'playbackControls'
              children: [
                React.DOM.i
                  className: 'fa fa-backward PlaybackControl'
                  id: 'playerBack'
                React.DOM.i
                  className: 'fa fa-play PlaybackControl'
                  id: 'playerPlay'
                React.DOM.i
                  className: 'fa fa-pause PlaybackControl'
                  id: 'playerPause'
                React.DOM.i
                  className: 'fa fa-forward PlaybackControl'
                  id: 'playerForward'
              ]
          ]
      ]
})

GridBox = React.createClass({
  render: ->
    React.DOM.div
      className: 'Cover'
      children: [
        React.DOM.img
          className: 'CoverImage'
          src: @props.track.artwork
        React.DOM.p
          className: 'TrackDetails'
          children: [
            React.DOM.span
              className: 'TrackName'
              children: @props.track.name
            React.DOM.span
              className: 'TrackArtist'
              children: @props.track.artist
          ]
      ]
})
Grid = React.createClass({
  getInitialState: ->
    return { tracks: [] }
  componentWillMount: ->
    $.get '/spotify/top_tracks', ((resp) ->
      @setState({ tracks: resp })).bind(this)
  componentDidMount: ->
    showTrackDetails = ->
      setTimeout((->
        $tds = $('.TrackDetails')
        if $tds.length > 0
          $tds.css('bottom', '0px')
        else showTrackDetails()
      ), 900)
    showTrackDetails()
  render: ->
    coverGrid = @state.tracks.map((track) -> GridBox({ track: track })
    )
    React.DOM.div
      className: if @props.isSearching then 'Searching' else ''
      id: 'coverGrid'
      children: coverGrid
})

SearchResults = React.createClass({
  render: ->
    if @props.results == null
      results = React.DOM.p
        children: ''
    else if @props.results == undefined
      results = React.DOM.h1
        id: 'searchResultsSearching'
        children: [
          React.DOM.span
            children: 'Searching'
          React.DOM.i
            className: 'fa fa-spin fa-spinner'
        ]
    else if @props.results.length == 0
      results = React.DOM.h1
        id: 'searchResultsNone'
        children: 'No results found'
    else
      children = @props.results.map((res) ->
        React.DOM.li
          className: 'SearchResult'
          children: [
            React.DOM.img
              className: 'SearchResultCover'
              width: '64'
              height: '64'
              src: res.cover
            React.DOM.div
              className: 'SearchResultDetails'
              children: [
                React.DOM.h2
                  className: 'SearchResultName'
                  children: res.name
                React.DOM.p
                  className: 'SearchResultAlbumArtist'
                  children: [
                    React.DOM.strong
                      children: res.artist 
                    React.DOM.span
                      children: ' | ' 
                    React.DOM.strong
                      children: res.albumName
                  ]
              ]
          ]
      )
      results = React.DOM.ol
        id: 'resultsList'
        children: children
    React.DOM.section
      id: 'searchResults'
      children: results
})
Search = React.createClass({
  _lastKeyDown: Date.now()
  getInitialState: ->
    return { results: null }
  componentDidMount: ->
    @refs.searchField.getDOMNode().focus()
  sendSearch: (q) ->
    setTimeout((->
      now = Date.now()
      keyDownTime = @._lastKeyDown
      diff = now - keyDownTime
      if diff < 500
        return
      $.get ('/search?q=' + q), ((resp) ->
        @setState({ results: resp.spotify })).bind(this)
    ).bind(this), 550)  # Additional delay to compensate for rounding errors etc
  search: ->
    query = @refs.searchField.getDOMNode().value
    query = encodeURIComponent(query).replace(/%20/g, '+')
    @._lastKeyDown = Date.now()
    @sendSearch(query)
    @setState({ results: undefined })
  render: ->
    React.DOM.section
      className: if @props.isSearching then 'Active' else ''
      id: 'searchView'
      children: [
        React.DOM.button
          className: 'InvisibleButton'
          id: 'dismissSearch'
          onClick: @props.dismissSearch
          children:
            React.DOM.i
              className: 'fa fa-times'
        React.DOM.main
          id: 'searchBody'
          children: [
            React.DOM.input
              type: 'text'
              id: 'searchField'
              ref: 'searchField'
              onKeyUp: @search
              placeholder: 'Find a song'
              autoComplete: 'off'
            SearchResults({ results: @state.results })
          ]
      ]
})
Homepage = React.createClass({
  getInitialState: ->
    { isSearching: true }
  startSearch: ->
    @setState({ isSearching: true })
  endSearch: ->
    @setState({ isSearching: false })
  render: ->
    React.DOM.div
      children: [
        Navbar({ isSearching: @state.isSearching, startSearch: @startSearch, endSearch: @endSearch })
        Grid({ isSearching: @state.isSearching })
        Search({ isSearching: @state.isSearching, dismissSearch: @endSearch })
      ]
})
React.renderComponent(Homepage(), document.getElementById('content'))