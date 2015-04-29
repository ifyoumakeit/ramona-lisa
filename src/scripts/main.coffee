window.jQuery = window.$ = require "../bower_components/jquery/dist/jquery.min"
_ = require "../bower_components/underscore/underscore-min"

Tabletop =  require("../bower_components/tabletop/src/tabletop").Tabletop
Handlebars = require 'Handlebars'

require "../bower_components/velocity/velocity.min"
require "../bower_components/unveil/jquery.unveil.min"
require "../bower_components/jquery.responsive-slides/jquery.responsive-slides.min"


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
    @$overlayClick.click      @showOverlay.bind(@)
    @$overlayClose.click      @hideOverlay.bind(@)
    @$overlayBackground.click @hideOverlay.bind(@)

  showOverlay: (e) ->
    log 'showOverlay'
    $overlayClick       = $(e.currentTarget)
    $overlayContainer   = $overlayClick.closest('.section').find('.overlay__container')
    $overlayView        = $overlayContainer.find('.overlay__view')

    id = $overlayClick.attr('data-video')
    src = "https://www.youtube.com/embed/#{id}?rel=0&modestbranding=1&autohide=1&showinfo=0&controls=0"

    @$body.addClass 'overlay'
    $overlayContainer.addClass 'open'
    $overlayView.attr 'src', src

  hideOverlay: (e) ->
    log 'hideOverlay'
    @$overlayContainers.removeClass('open')
    @$overlayContainers.find('.overlay__view').attr('src','')
    @$body.removeClass 'overlay'

  setupLazyLoad: ->
    log 'setupLazyLoad'
    $('img').unveil()

  setupAccordions: ->
    log 'setupAccordions'
    $('.accordion__row').click ->
      $el = $(@)
      $next = $(@).next(".accordion__media")

      if $next.css('display') is 'block'
        $next.find('.viewer').attr('src', '');
        $next.velocity 'slideUp'
        return

      $next.velocity 'slideDown',
        complete: ->
          $(@).find('.viewer').attr('src', $next.find('.viewer').attr('data-src'));

      $next.siblings('.accordion__media:visible').velocity 'slideUp',
        complete: ->
          console.log $(@).find('.viewer')
          $(@).find('.viewer').attr('src', '');
          $el.velocity('stop').velocity 'scroll'

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

  setupHelpers: ->
    log 'setupHelpers'
    Handlebars.registerHelper 'media', (item) ->
      log item
      unless item?
        return ''

      if item.indexOf('.') > 0
        url = 'http://googledrive.com/host/0Bx6GaEGEXpl8flY4Q3pWbEVsYW42YzAwMTh6UGF3ZGtjam5tNlFmdTc4NTlRM2kzRjFuZlk/'
        output = "<img src='images/loader.jpg' class='viewer' data-src='#{url}#{item}' />"
      else
        url = "https://www.youtube.com/embed/#{item}?rel=0&modestbranding=1&autohide=1&showinfo=0&controls=0"
        output = "<div src='images/loader.jpg' class='video__holder'><iframe frameborder='0' class='viewer video__viewer' data-src='#{url}'></iframe></div>"

      new Handlebars.SafeString output

  setupTemplates: ->
    template = Handlebars.compile @$template.html()

    $("#photos").append         template(@data.Photos.elements)
    $("#choreographies").append template(@data.Choreography.elements)
    $("#performances").append   template(@data.Performance.elements)

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

    @$pages.responsiveSlides
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

