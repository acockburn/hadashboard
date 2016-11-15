class Dashing.Halock extends Dashing.ClickableWidget
  constructor: ->
    super
    @queryState()

  @accessor 'state',
    get: -> @_state ? 'unlocked'
    set: (key, value) -> @_state = value

  @accessor 'icon',
    get: -> if @get('state') == 'unlocked' then 'unlock-alt' else 'lock'
    set: Batman.Property.defaultAccessor.set

  @accessor 'icon-style', ->
    if @get('state') == 'locked' then 'icon-locked' else 'icon-unlocked'

  toggleState: ->
    newState = if @get('state') == 'locked' then 'unlock' else 'lock'
    @set 'state', newState
    return newState

  queryState: ->
    $.get '/homeassistant/lock',
      widgetId: @get('id'),
      (data) =>
        json = JSON.parse data
        @set 'state', json.state

  postState: ->
    newState = @toggleState()
    $.post '/homeassistant/lock',
      widgetId: @get('id'),
      command: newState,
      (data) =>
        json = JSON.parse data
        if json.error != 0
          @toggleState()
  ready: ->
    if @get('bgcolor')
      $(@node).css("background-color", @get('bgcolor'))

  onData: (data) ->

  onClick: (event) ->
    @postState()
