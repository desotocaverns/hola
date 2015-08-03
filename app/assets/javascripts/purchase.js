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
      alert('error');
    } else {
      var stripe_token = response.id;
      // alert(stripe_token)
      var url = document.URL + 'purchase';
      $.post(url, {token: stripe_token})
        .done(function (data) {
          window.location.href = document.URL + 'success';
        });
      // alert('finished')
    }
  }
});
