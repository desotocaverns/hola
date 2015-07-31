$( document ).ready( function() {
  Stripe.setPublishableKey('pk_test_lgoJadzJlZSpLwrY1sJPinZK'); // This is a test key. Don't deploy it to production.

  jQuery(function($) {
    $('#payment-form').submit(function(event) {
      var $form = $(this);
      $form.find('button').prop('disabled', true);
      Stripe.card.createToken($form, stripeResponseHandler);
      return false;
    });
  });

  function stripeResponseHandler(status, response) {
    var $form = $('#payment-form');
    if (response.error) {
      alert("error");
    } else {
      var token = response.id;
      alert(token);
      // var url = "http://api.desotocaves.com/purchase/" + token;
      // $.get(url, function(response) {
      //
      // });
    }
  }
});
