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

    $el = $(e.currentTarget)
    @$overlayViewer.removeClass '-photo'
    @$overlayContainer.removeClass '-photo'

    if $el.attr('data-video')
      id = $el.attr('data-video')
      src = "//www.youtube.com/embed/#{id}?rel=0&modestbranding=1&autohide=1&showinfo=0&controls=1&hd=1&vq=large&autoplay=1"
      @$overlayIframe.attr('src', src)
    else
      src = $el.attr('href')
      @$overlayViewer.addClass '-photo'
      @$overlayContainer.addClass '-photo'
      @$overlayImage.attr('src', src)

    @$html.addClass 'overlay'
    @$overlayContainer.addClass 'open'

    return false

  hideOverlay: (e) ->
    $('iframe').attr('src', '')

    @$overlayContainer.removeClass('open')
    @$html.removeClass 'overlay'

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
    @$html   = $ 'html'
    @$main   = $ 'main'

    @$nav       = $ '.main'
    @$nav       = $ '.navigation'
    @$navToggle = $ '.navigation__toggle'
    @$navItems  = @$nav.find '.navigation__link'
    @$sections  = $ '.section'


    @$overlayBackground = $ '.overlay__background'
    @$overlayContainer  = @$overlayBackground.find '.overlay__container'
    @$overlayView =       @$overlayBackground.find '.overlay__view'
    @$overlayViewer =     @$overlayBackground.find '.overlay__viewer'
    @$overlayClose =      @$overlayBackground.find '.overlay__close'
    @$overlayImage =      @$overlayBackground.find '.overlay__img'
    @$overlayIframe =     @$overlayBackground.find '.overlay__iframe'

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

