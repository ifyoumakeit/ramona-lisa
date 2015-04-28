window.jQuery = window.$ = require "../bower_components/jquery/dist/jquery.min"
_ = require "../bower_components/underscore/underscore-min"

require "../bower_components/velocity/velocity.min"
require "../bower_components/unveil/jquery.unveil.min"
require "../bower_components/jquery.responsive-slides/jquery.responsive-slides.min"
Tabletop = require("../bower_components/tabletop/src/tabletop").Tabletop

Handlebars = require 'Handlebars'

log = ->
  log.history = log.history || []
  log.history.push arguments
  if @console
    css = 'background: #222; color: #bada55; padding: 2px'
    console.log '%c Ramona Lisa ', css , Array.prototype.slice.call arguments


class RamonaLisa

  setHeights: ->
    log 'setHeights'
    @isMobile = @$navToggle.is ':visible'
    @$sections.css 'min-height', $(window).height()

    @$nav.removeClass('closed') unless @isMobile

  prepareSections: ->
    log 'prepareSections'
    @setHeights()
    $(window).resize _.debounce @setHeights.bind(@), 500

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
    @$overlayClick.click @showOverlay.bind(@)
    @$overlayClose.click @hideOverlay.bind(@)
    @$overlayBackground.click @hideOverlay.bind(@)

  showOverlay: (e) ->
    log 'showOverlay'
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
    $overlayContainer.velocity
      translateZ: 0
      translateX: '-50%'
      translateY: '-50%'
      complete: -> $overlayView.attr 'src', src

  hideOverlay: (e) ->
    log 'hideOverlay'
    @$overlayContainers.velocity
      translateZ: 0
      translateX: '-50%'
      translateY: '-400%'
      complete: ->
        $('body').removeClass 'overlay'
        $(@).find('.overlay__view').attr('src','')

  setupLazyLoad: ->
    log 'setupLazyLoad'
    $('img').unveil()

  setupAccordions: ->
    log 'setupAccordions'
    $('.accordion__row').click ->
      $el = $(@)
      $next = $(@).next(".accordion__media")

      if $next.css('display') is 'block'
        $next.velocity 'slideUp'
        return

      $next.velocity 'slideDown'
      $next.siblings('.accordion__media').velocity 'slideUp',
        complete: -> $el.velocity('stop').velocity 'scroll'

  cacheJQuery: ->
    log 'cacheJQuery'
    @$body   = $ 'body'

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

  setupLyricsSlider: ->
    log 'setupLyricsSlider'
    $('.section__arrow--right').click @arrowRightClick.bind(@)
    $('.section__arrow--left').click @arrowLeftClick.bind(@)

  arrowRightClick: -> @$pages.velocity translateX: "-=6.666666%"
  arrowLeftClick: -> @$pages.velocity translateX: "+=6.666666%"

  setupHelpers: ->
    log 'setupHelpers'
    Handlebars.registerHelper 'media', (item) ->
      log item
      unless item?
        return ''


      if item.indexOf('.') > 0
        url = 'http://googledrive.com/host/0Bx6GaEGEXpl8flY4Q3pWbEVsYW42YzAwMTh6UGF3ZGtjam5tNlFmdTc4NTlRM2kzRjFuZlk/'
        output = "<img src='#{url}#{item}' />"
      else
        url = "https://www.youtube.com/embed/#{item}?rel=0&modestbranding=1&autohide=1&showinfo=0&controls=0"
        output = "<div class='video__holder'><iframe class='video__viewer' src='#{url}'></iframe></div>"

      new Handlebars.SafeString output

  setupTemplates: ->
    template = Handlebars.compile @$template.html()

    $("#photos").append template(@data.Photos.elements)
    $("#choreographies").append template(@data.Choreography.elements)
    $("#performances").append template(@data.Performance.elements)

  init: (data, tabletop) ->
    log 'init'
    @data = data
    @tabletop = tabletop

    @cacheJQuery()
    @prepareSections()
    @setupLazyLoad()
    @setupNavigation()
    @setupOverlays()
    @setupHelpers()
    @setupTemplates()
    @setupAccordions()

    $(".section__pages").responsiveSlides
      auto: false
      nav: true
      namespace: 'section__pages'
      prevText: "&lsaquo;"
      nextText: "&rsaquo;"



$ ->
  RamonaLisa = new RamonaLisa
  Tabletop.init(
    key: 'https://docs.google.com/spreadsheets/d/1R0SF7drKgJ1l-jlgzthPfhL9KCFkbjjgz2Gd9WMkQGY/pubhtml'
    debug: true
    callback: RamonaLisa.init.bind(RamonaLisa)
  )

