$(document).on('ready', function(){
  setupHandlers();
});

function setupHandlers() {
  $('body').on('click', '[data-toggle],[data-show],[data-hide],[data-toggle-class]', function(event) {
    Toggler.handle(this)
    event.stopPropagation()
    event.preventDefault()
  })
}
