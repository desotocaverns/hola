$(document).on('ready', function(){
  $("input, textarea, select").on({ 'touchstart' : function() {
      zoomDisable()
  }})
  $("input, textarea, select").on({ 'touchend' : function() {
      setTimeout(zoomEnable, 1000)
  }})
})

function zoomDisable(){
  $('#viewport-zoomfix').remove()
  $('head').append('<meta id="viewport-zoomfix" name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=0" />')
}
function zoomEnable(){
  $('#viewport-zoomfix').remove()
  $('head').append('<meta id="viewport-zoomfix" content="width=device-width, initial-scale=1.0" name="viewport">')
} 
