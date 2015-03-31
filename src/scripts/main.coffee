window.jQuery = window.$ = require "../bower_components/jquery/jquery.min"
_ = require "../bower_components/underscore/underscore-min"

require "../bower_components/velocity/velocity.min"
require "../bower_components/unveil/jquery.unveil.min"


class RamonaLisa

  setHeights: ->
    @isMobile = @$navToggle.is ':visible'
    @$sections.css 'min-height', $(window).height()

  prepareSections: ->
    @setHeights()
    $(window).resize _.debounce @setHeights.bind(@), 500

    @$sections.velocity 'fadeIn',
      duration: 500

  setupNavigation: ->

    @$navItems.click   @handleNavClick.bind(@)
    @$navToggle.click  @toggleNav.bind(@)

  handleNavClick: (e) ->
      e.preventDefault()
      id = $(e.currentTarget).attr('href')
      $(id).velocity 'scroll',
        duration: 750,
        easing: 'ease-in-out'
        complete: @toggleNav.bind(@)

  toggleNav: ->
    x = if @$nav.css('left') is '5px' then '-100%' else '5px'
    x = if @isMobile then x else '5px'
    @$nav.velocity
      left: x
      easing: 'ease-in-out'
      duration: 750

  setupVideo: ->
    $video = $ '.video'
    $videoViewer = $ '.video__viewer'
    $videoView = $videoViewer.find('.video__view')

    $video.click (e) ->
      id = $(e.currentTarget).attr('data-video')
      $videoViewer.velocity
        paddingBottom: '56.25%'
        duration: 500,
        easing: 'ease-in-out'
        complete: ->
          $videoView.attr 'src', "https://www.youtube.com/embed/#{id}?rel=0&modestbranding=1&autohide=1&showinfo=0&controls=0"
          $videoViewer.velocity 'scroll'
            easing: 'ease-in-out'

  setupPhoto: ->
    $photo = $ '.photo'
    $photoViewer = $ '.photo__viewer'
    $photoView = $photoViewer.find('.photo__view')

    $photo.click (e) ->
      img_url = $(e.currentTarget).find('img').attr 'src'
      $photoViewer
        .velocity
          paddingBottom: '56.25%'
          duration: 500,
          easing: 'ease-in-out'
          complete: ->
            $photoView.attr 'src', img_url
            $photoViewer.velocity 'scroll'
              easing: 'ease-in-out'

  setupLazyLoad: ->
    $('[data-src]').unveil()

  cacheJQuery: ->
    @$nav       = $ '.navigation'
    @$navToggle = $ '.navigation__toggle'
    @$navItems  = @$nav.find '.navigation__link'
    @$sections  = $ '.section'

  init: ->
    @cacheJQuery()
    @prepareSections()
    @setupNavigation()
    @setupVideo()
    @setupPhoto()

$ -> (new RamonaLisa).init()
