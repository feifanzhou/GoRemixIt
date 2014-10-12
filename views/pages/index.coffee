Homepage = React.createClass({
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
React.renderComponent(Homepage(), document.getElementById('content'))