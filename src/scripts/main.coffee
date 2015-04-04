window.jQuery = window.$ = require "../bower_components/jquery/jquery.min"
_ = require "../bower_components/underscore/underscore-min"

require "../bower_components/velocity/velocity.min"
require "../bower_components/unveil/jquery.unveil.min"


class RamonaLisa

  setHeights: ->
    @isMobile = @$navToggle.is ':visible'
    @$sections.css 'min-height', $(window).height()

    @$nav.removeClass('closed') unless @isMobile

  prepareSections: ->
    @setHeights()
    $(window).resize _.debounce @setHeights.bind(@), 500

  setupNavigation: ->

    @$navItems.click   @handleNavClick.bind(@)
    @$navToggle.click  @toggleNav.bind(@)

  handleNavClick: (e) ->
      e.preventDefault()
      id = $(e.currentTarget).attr('href')
      $(id).velocity 'scroll',
        duration: 500,
        easing: 'ease-in-out'
        complete: @toggleNav.bind(@)

  toggleNav: -> @$nav.toggleClass 'closed'

  setupOverlays: ->
    @$overlayClick.click @showOverlay.bind(@)
    @$overlayClose.click @hideOverlay.bind(@)
    @$overlayBackground.click @hideOverlay.bind(@)

  showOverlay: (e) ->
    $overlayClick       = $(e.currentTarget)
    $overlayContainer   = $overlayClick.closest('.section').find('.overlay__container')
    $overlayView        = $overlayContainer.find('.overlay__view')

    isVideo = $overlayClick.attr('data-video')
    if isVideo?
      id = $overlayClick.attr('data-video')
      src = "https://www.youtube.com/embed/#{id}?rel=0&modestbranding=1&autohide=1&showinfo=0&controls=0"
    else
      src = $overlayClick.find('img').attr('src')

    @$body.addClass 'overlay'
    $overlayContainer.addClass 'open'
    $overlayView.attr 'src', src

  hideOverlay: (e) ->

    @$body.removeClass 'overlay'
    @$overlayContainers.removeClass 'open'
    @$overlayContainers.find('.overlay__view').attr('src','')

  setupLazyLoad: ->  $('img').unveil()

  cacheJQuery: ->
    @$body   = $ 'body'

    @$nav       = $ '.navigation'
    @$navToggle = $ '.navigation__toggle'
    @$navItems  = @$nav.find '.navigation__link'
    @$sections  = $ '.section'

    @$overlayBackground = $ '.overlay__background'
    @$overlayContainers   = $ '.overlay__container'
    @$overlayClose = @$overlayBackground.find '.overlay__close'
    @$overlayClick = $ '.overlay__click'

  init: ->
    @cacheJQuery()
    @prepareSections()
    @setupLazyLoad()
    @setupNavigation()
    @setupOverlays()


$ -> (new RamonaLisa).init()
