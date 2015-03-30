window.jQuery = window.$ = require "../bower_components/jquery/jquery.min"
_ = require "../bower_components/underscore/underscore-min"
require "../bower_components/velocity/velocity.min"
require "../bower_components/velocity/velocity.ui.min"

class RamonaLisa

  setHeights: ->
    @$sections.css 'min-height', $(window).height()

  prepareSections: ->
    @setHeights()
    $(window).resize _.debounce @setHeights

  cacheJQuery: ->
    @$sections = $ '.section'
    @$nav = $ '.navigation'
    @$navItems = @$nav.find '.navigation__link'
    @$navToggle = $ '.navigation__toggle'

  setupNavigation: ->
    @$navItems.click (e) ->
      e.preventDefault()
      id = $(e.currentTarget).attr('href')
      console.log id
      $(id).velocity 'scroll'

    @$navToggle.click @toggleNav.bind(@)

  toggleNav: (e) ->
    if @$nav.css('left') is '5px'
      @$nav.velocity 'left': '-100%'
    else
      @$nav.velocity 'left': '5px'

  init: ->

    @cacheJQuery()
    @prepareSections()
    @setupNavigation()


$ -> (new RamonaLisa).init()
