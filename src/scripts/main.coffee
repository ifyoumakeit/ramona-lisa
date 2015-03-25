#this is the main file that pulls in all other modules
$ ->
  layout = require('./layout')
  onepage = require('onepage-scroll')

  layout.set()
  $(window).resize layout.set

  console.log onepage, layout

