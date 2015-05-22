window.$ = window.jQuery = require "../bower_components/jquery/dist/jquery.min"

[
  _

  Handlebars

  Photos
  Performance

  Velocity
  ResponsiveSlides
] = [
  require "../bower_components/lodash/lodash.min"

  require 'Handlebars'

  require './photos'
  require './performance'

  require "../bower_components/velocity/velocity.min"
  require "../bower_components/jquery.responsive-slides/jquery.responsive-slides.min"
]

log = ->
  log.history = log.history || []
  log.history.push arguments
  if @console
    css = 'background: #222; color: #bada55; padding: 2px'
    console.log '%c Ramona Lisa ', css , Array.prototype.slice.call arguments

class RamonaLisa

  setupNavigation: ->
    log 'setupNavigation'
    @$navItems.click   @handleNavClick.bind(@)
    @$navToggle.click  @toggleNav.bind(@)

  handleNavClick: (e) ->
    log 'handleNavClick'
    e.preventDefault()
    id = $(e.currentTarget).attr('href')
    $(id).velocity 'scroll',
      duration: 750,
      easing: 'ease-in-out'
      complete: @toggleNav.bind(@)

  toggleNav: ->
    log 'toggleNav'
    @$nav.toggleClass 'closed'

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
    src = "//www.youtube.com/embed/#{id}?rel=0&modestbranding=1&autohide=1&showinfo=0&controls=0"


    $overlayView.attr('src', src).load =>
      @$body.addClass 'overlay'
      $overlayContainer.addClass 'open'


  hideOverlay: (e) ->
    log 'hideOverlay'
    @$overlayContainers.removeClass('open')
    @$body.removeClass 'overlay'

  setupLazyLoad: ->
    log 'setupLazyLoad'

  setupAccordions: ->
    log 'setupAccordions'
    $('.accordion__click').click ->
      $el = $(@)
      $next = $(@).next(".accordion__target")

      if $next.css('display') is 'block'
        $next.find('.viewer').attr('src', '');
        $next.velocity 'slideUp'
        return

      $next.velocity 'slideDown',
        complete: ->
          $(@).find('.viewer').attr('src', $next.find('.viewer').attr('data-src'));
          $el.velocity('stop').velocity 'scroll'

      $next.siblings('.accordion__target:visible').velocity 'slideUp',
        complete: ->
          $(@).find('.viewer').attr('src', '');

  cacheJQuery: ->
    log 'cacheJQuery'
    @$body   = $ 'body'

    @$nav       = $ '.main'
    @$nav       = $ '.navigation'
    @$navToggle = $ '.navigation__toggle'
    @$navItems  = @$nav.find '.navigation__link'
    @$sections  = $ '.section'

    @$overlayBackground = $ '.overlay__background'
    @$overlayContainers   = $ '.overlay__container'
    @$overlayClose = @$overlayBackground.find '.overlay__close'
    @$overlayClick = $ '.overlay__click'

    @$template = $("#entry-template")

    @$pages = $(".section__pages")

  setupTemplates: ->
    template =
      photo: Handlebars.compile $("#photo-template").html()
      performance: Handlebars.compile $("#performance-template").html()

    $("#photos").append         template.photo(Photos)
    $("#performances").append   template.performance(Performance)

  init: ->
    log 'init'

    @cacheJQuery()
    @setupLazyLoad()
    @setupNavigation()
    @setupOverlays()
    @setupTemplates()
    @setupAccordions()

    @$pages.responsiveSlides
      auto: false
      nav: true
      namespace: 'section__pages'
      prevText: "&lsaquo;"
      nextText: "&rsaquo;"

$ ->
  (new RamonaLisa).init()

