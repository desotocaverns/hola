var Toggler = {
  handle: function(el) {
    if (toggle = $(el).data('toggle')){
      $(toggle).toggleClass('hidden')
    }
    if (hide = $(el).data('hide')){
      $(hide).addClass('hidden')
    }
    if (show = $(el).data('show')){
      $(show).removeClass('hidden')
    }
    if (toggleClass = $(el).data('toggleClass')){
      tc = toggleClass.split(';')
      $(tc[0]).toggleClass(tc[1])
    }
  }
}
