DCPurchase = {
  init: function(packages) {
    console.log(packages);
  }
};

$( document ).ready( function() {
  Stripe.setPublishableKey('pk_test_lgoJadzJlZSpLwrY1sJPinZK'); // This is a test key. Don't deploy it to production.

  jQuery(function($) {
    $('#payment_form').submit(function(event) {
      var $form = $(this);
      $form.find('button').prop('disabled', true);

      // Synchronous call (Stripe explicit)
      Stripe.card.createToken($form, function(status, response) {
        if (response.error) {
          $('.payment_errors').remove();
          $('<div class="payment_errors"><ul><li class="error_text" style="color:red"></li></ul></div>').insertAfter('#errors');

          $('.error_text').text(response.error.message);

          $form.find('button').prop('disabled', false);
        } else {
          var stripe_token = response.id;
          var package_form = $('#package_form');
          package_form.find('#stripe_token').val(stripe_token);
          package_form.submit()
        }
      });

      return false;
    });
  });
});
