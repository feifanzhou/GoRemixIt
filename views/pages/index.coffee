Homepage = React.createClass({
  render: ->
    React.DOM.p
      children: 'Hi'
})
React.renderComponent(Homepage(), document.getElementById('content'))