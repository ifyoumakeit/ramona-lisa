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

    @$sections.velocity 'fadeIn',
      duration: 500

  setupNavigation: ->
    $nav = $ '.navigation'
    $navItems = $nav.find '.navigation__link'
    $navToggle = $ '.navigation__toggle'

    $navItems.click (e) ->
      e.preventDefault()
      id = $(e.currentTarget).attr('href')
      $(id).velocity 'scroll',
        duration: 500,
        easing: 'ease-in-out'

    $navToggle.click ->
      x = if $nav.css('left') is '5px' then '-100%' else '5px'
      $nav.velocity 'left': x

  setupVideo: ->
    $videoBox = $ '.video__viewer:not(.video__viewer--main)'
    $videoViewer = $ '.video__viewer--main'
    $videoView = $videoViewer.find('.video__view')

    $videoBox.click (e) ->
      id = $(e.currentTarget).attr('data-video')
      console.log $(e.currentTarget).attr('data-video')
      console.log $(e.currentTarget)
      $videoViewer.velocity
        paddingBottom: '56.25%'
        complete: ->
          $videoView.attr 'src', "https://www.youtube.com/embed/#{id}?rel=0&modestbranding=1&autohide=1&showinfo=0&controls=0"



  init: ->
    @$sections = $ '.section'
    @prepareSections()
    @setupNavigation()
    @setupVideo()


$ -> (new RamonaLisa).init()
