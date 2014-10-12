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
Grid = React.createClass({
  getInitialState: ->
    return { covers: [] }
  componentWillMount: ->
    $.get '/spotify/top_tracks', ((resp) ->
      @setState({ covers: resp })).bind(this)
  render: ->
    coverGrid = @state.covers.map((cover) ->
      React.DOM.div
        className: 'Cover'
        children:
          React.DOM.img
            className: 'CoverImage'
            src: cover
    )
    React.DOM.div
      id: 'coverGrid'
      children: coverGrid
})
Homepage = React.createClass({
  render: ->
    React.DOM.div
      children: [
        Navbar()
        Grid()
      ]
})
React.renderComponent(Homepage(), document.getElementById('content'))