'use strict'

$(document).ready ->

  # jQuery
  $filters = $('.filter')
  $pageContainer = $('.page-container')
  $posts = $pageContainer.find('.post')
  $menu = $('.menu')
  currentPosition = 0

  # Helpers
  deActivateFilters = -> $filters.each( -> $(this).removeClass('active') )

  ###
    Section class
  ###

  class Section
    constructor: (@name, @$el, @scrollOffset = 0)->
      @status = before: true, active: false, past: false
      @offset = top: null, bottom: null
      @speed = 1500 # pixels/s

      $(window).load @_setOffset

    _setOffset: =>
      @offset =
        top: @$el?.offset().top
        bottom: @$el?.offset().top + @$el.outerHeight()

    is: (what)=> !!@status[what]

    get: (what)=> @[what]

    set: (what, to)=>
      return null unless @[what]
      return @[what] = to

    _getSpeed: (distance)=> (Math.abs(distance)/@speed) * 1000

    go: =>
      distance = (@offset.top - @scrollOffset) - currentPosition
      ms = @_getSpeed(distance)
      $('.wrapper').animate(
        scrollTop: @offset.top - @scrollOffset
      , ms)

  ###
    Menu class
  ###
  class Menu

    constructor: (@$el, @sections)->
      @$body = $('body')
      @links = internal: $('.side-menu-link.internal')
      @active = false

      @$el.on 'click', => @toggle()
      @links.internal.on 'click', @go

    toggle: (force = false, callback, args...)=>
      @$body.toggleClass('menu-active', force) if force
      @$body.toggleClass('menu-active') unless force
      @active = @$body.hasClass('menu-active')
      setTimeout(callback.apply(@, args), 0) if callback

    setActive: (which)->
      @links.internal.each ->
        unless ($item = $(@)).attr('href') == "##{which}"
          $item.removeClass('active')
        else
          $item.addClass('active')
          return
      @

    isActive: => @active

    go: (ev)=>
      return @toggle(false, @sections[ev].go) unless typeof ev == "object"

      ev.preventDefault()
      ev.stopPropagation()

      target = $(ev.target).attr('href').substr(1)
      @setActive target
      @toggle(false, @sections[target].go)


  ###
    Scroll class
  ###
  class Scroll
    constructor: (@sections, @Menu, @offset)->
      @_init()

    _init: =>
      # elements to track
      @$el = $('.wrapper')
      @$other =
        menu: $('.menu')
        footer: $('footer')
        myWorkMenu: $('#my-work-menu')

      @borders = []

      $(window).load @_setup

      @_listen()

    getPosition: => (currentPosition = @$el.scrollTop()+@offset)

    _setup: =>
      for name, section of @sections
        @borders.push(
          {
            section: section
            offset: section.get('offset')
            index: @borders.length
          }
        )

      @borders.sort( (a,b)-> a.offset.top-b.offset.top )
      @_current = @_getCurrent()

    _getCurrent: =>
      pos = @getPosition()
      for border in @borders
        return border if pos < border.offset.bottom and pos >= border.offset.top

    _listen: =>
      @$el.on 'scroll', =>

        pos = @getPosition()
        @_setCurrent(pos)


        if @sections.home.is('past')

          if @sections['my-work'].is('active')
            @$other.myWorkMenu.removeClass('hide')
          else
            @$other.myWorkMenu.addClass('hide')

          @$other.menu.addClass('scroll')
          #$imageOverlay.addClass('hide')
          @$other.footer.removeClass('hidden')
        else
          #$imageOverlay.removeClass('hide')
          @$other.menu.removeClass('scroll')
          @$other.footer.addClass('hidden')
      return

    _setCurrent: (pos)=>
      if pos > @_current?.offset.bottom
        @_current?.section.set('status',
          {
            past: true
            active: false
            before: false
          }
        )
        @_current = @borders[@_current.index+1]
        @Menu.setActive @_current.section.name
        @_current?.section.set('status',
          {
            past: false
            active:true
            before: false
          }
        )
      else if pos < @_current?.offset.top
        @_current?.section.set('status',
          {
            past: false
            active:false
            before: true
          }
        )
        @_current = @borders[@_current.index-1]
        @Menu.setActive @_current.section.name
        @_current?.section.set('status',
          {
            past: false
            active:true
            before: false
          }
        )
      return

    getActiveSection: => @_current.section.get('name')


  # Sections
  sections =
    home: new Section('home', $('#home'))
    about: new Section('about', $('#about'), 300)
    'my-work': new Section('my-work', $('#my-work'), $menu.outerHeight())
    contact: new Section('contact', $('#contact'), $('.menu').outerHeight())

  Menu = new Menu($('.menu .icon'), sections)
  Scroll = new Scroll(sections, Menu, $menu.outerHeight() )


  $filters.on 'click', (e)->

    deActivateFilters()
    target = $(e.target).addClass('active').data('target')

    $posts.each(
      ->
        post = $(this)
        if target in [post.data('category'), 'all']
          post.addClass('show')
        else
          post.removeClass('show')
        return
    )
    return



