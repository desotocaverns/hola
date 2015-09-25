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
  }
}
