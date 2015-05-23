window.$ = window.jQuery = require "../bower_components/jquery/dist/jquery.min"

[
  Velocity
  ResponsiveSlides
] = [
  require "../bower_components/velocity/velocity.min"
  require "../bower_components/jquery.responsive-slides/jquery.responsive-slides.min"
]

log = -> return false

class RamonaLisa

  options:
    duration: 200
    easing: 'swing'

  setupNavigation: ->
    log 'setupNavigation'
    @$navItems.click   @handleNavClick.bind(@)
    @$navToggle.click  @toggleNav.bind(@)

  handleNavClick: (e) ->
    log 'handleNavClick'
    e.preventDefault()
    id = $(e.currentTarget).attr('href')
    @$nav.removeClass 'open'
    @$main.removeClass 'open'
    $(id).velocity 'scroll',
      delay: 600,
      duration: 600,
      easing: 'ease-in-out'

  toggleNav: ->
    log 'toggleNav'
    @$nav.toggleClass 'open'
    @$main.toggleClass 'open'

  setupOverlays: ->
    log 'setupOverlays'
    @$overlayClick.click      @showOverlay.bind(@)
    @$overlayClose.click      @hideOverlay.bind(@)
    @$overlayBackground.click @hideOverlay.bind(@)

  showOverlay: (e) ->
    log 'showOverlay'
    $overlayClick       = $(e.currentTarget)
    $overlayContainer   = $overlayClick.closest('.section').find('.overlay__container')
    $overlayView        = $overlayContainer.find('.overlay__view')

    id = $overlayClick.attr('data-video')
    src = "//www.youtube.com/embed/#{id}?rel=0&modestbranding=1&autohide=1&showinfo=0&controls=1"

    $overlayView.attr('src', src)
    @$body.addClass 'overlay'
    $overlayContainer.addClass 'open'

  hideOverlay: (e) ->
    $('iframe').attr('src', '')

    @$overlayContainers.removeClass('open')
    @$body.removeClass 'overlay'

  setupAccordions: ->
    log 'setupAccordions'
    $('.accordion__click').click ->

      $next = $(@).next(".accordion__target")

      if $next.hasClass 'open'
        $next.removeClass 'open'
        return

      $next.addClass 'open'
      $next.siblings('.open').removeClass 'open'

  cacheJQuery: ->
    log 'cacheJQuery'
    @$body   = $ 'body'
    @$main   = $ 'main'

    @$nav       = $ '.main'
    @$nav       = $ '.navigation'
    @$navToggle = $ '.navigation__toggle'
    @$navItems  = @$nav.find '.navigation__link'
    @$sections  = $ '.section'


    @$overlayBackground = $ '.overlay__background'
    @$overlayContainers   = $ '.overlay__container'
    @$overlayClose = @$overlayBackground.find '.overlay__close'
    @$overlayClick = $ '.overlay__click'

    @$pages = $(".section__pages")

  init: ->
    log 'init'

    @cacheJQuery()
    @setupNavigation()
    @setupOverlays()
    @setupAccordions()

    @$pages.responsiveSlides
      auto: false
      nav: true
      namespace: 'section__pages'
      prevText: "&lsaquo;"
      nextText: "&rsaquo;"

$ ->
  (new RamonaLisa).init()

