$(document).on('ready', function(){
  TicketStore.listen();
});

var TicketStore = {
  listen: function() {
    // Toggler
    $('body').on('click', '[data-toggle],[data-show],[data-hide],[data-toggle-class]', function(event) {
      Toggler.handle(this)
      event.stopPropagation()
      event.preventDefault()
    })

    // Update cart without checking out or showing validation errors on name/email
    //
    $('body').on('click', '#update-cart', function(event) {
      $('input[name=update_cart]').attr('value', true)
    })

    // Show add to cart button when ticket quantity is selected
    //
    $('body').on('change', 'select.ticket-quantity', function(event) {
      var button = $(".button-wrapper[data-id='"+$(this).data('id')+"']")
      if (this.value != '0') {
        button.removeClass('hidden');
      } else {
        button.addClass('hidden');
      }
    })

    // Mark ticket/package element for replacement when a ticket is added to the cart
    //
    $('body').on('submit', 'form.add-ticket-form', function(event) {
      $('[data-ticket-id="'+$(this).data('id')+'"]').addClass('added-to-cart');
    })
  },

  updateTicketForms: function(content) {
    $("body").append("<div class='hidden ticket-template'>"+content+"</div>")
    var action = $('.ticket-template .add-ticket-form').attr('action')

    $('.added-to-cart').each(function() {
      var id = $(this).data('ticket-id')
      var count = $(this).find('select').val()
      var name = ' ' + $(this).find('.ticket-name').text()
      name += (count == '1' ? '' : 's')
      TicketStore.showMessage({text: 'Added '+ count + name +' to your cart.', icon: 'cart'})
      $(this).replaceWith($('.ticket-template [data-ticket-id="'+id+'"]'))
    })
    $('.ticket-template').remove()
    $('.add-ticket-form').attr('action', action)
    $('.add-ticket-form input[name=_method]').attr('value', 'patch')
  },

  showMessage: function(options) {
    $('#app-message-text').html(options.text || '')
    var icon = $('#app-message-icon')
    icon.find('.svg-icon').addClass('hidden')

    if (options.icon) {
      icon.find('.icon-'+options.icon).removeClass('hidden')
    }
    $('#app-message').addClass('visible')
    setTimeout(function(){ $('#app-message').addClass('hiding')}, 2200)
    setTimeout(function(){ $('#app-message').removeClass('hiding visible')}, 2500)
  }
}
