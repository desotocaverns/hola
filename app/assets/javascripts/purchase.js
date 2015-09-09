$(document).on('ready', function(){
  setupHandlers();
});

function setupHandlers() {
  $('body').on('change', '.number-input', function() {
    console.log(Number(this.value) + 1)
  })
}
