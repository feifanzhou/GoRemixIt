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
              onClick: @props.startSearch
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
    setTimeout((->
      console.log('Showing track details')
      $('.TrackDetails').css('bottom', '0px')
    ), 900)
  render: ->
    coverGrid = @state.tracks.map((track) -> GridBox({ track: track })
    )
    React.DOM.div
      className: if @props.isSearching then 'Searching' else ''
      id: 'coverGrid'
      children: coverGrid
})
Homepage = React.createClass({
  getInitialState: ->
    { isSearching: false }
  startSearch: ->
    @setState({ isSearching: true })
  render: ->
    React.DOM.div
      children: [
        Navbar({ startSearch: @startSearch })
        Grid({ isSearching: @state.isSearching })
      ]
})
React.renderComponent(Homepage(), document.getElementById('content'))