// DCPurchase = {
//   init: function(packages) {
//     console.log(packages);
//   }
// };

$( document ).ready( function() {
  Stripe.setPublishableKey('pk_test_lgoJadzJlZSpLwrY1sJPinZK'); // This is a test key. Don't deploy it to production.

  var package_form = $('#package_form');
  var payment_form = $('#payment_form');

  var stripe_card_number_field = payment_form.find('#card_number'),
      stripe_cvc_field = payment_form.find('#cvc'),
      stripe_exp_month_field = payment_form.find('#exp_month'),
      stripe_exp_year_field = payment_form.find('#exp_year');

  var stripe_token_field = package_form.find('#stripe_token'),
      hidden_card_number_field = package_form.find('#hidden_card_number'),
      hidden_cvc_field = package_form.find('#hidden_cvc'),
      hidden_exp_field = package_form.find('#hidden_exp');

  if (hidden_card_number_field.val() != '') {
    stripe_card_number_field.val(hidden_card_number_field.val());
    stripe_cvc_field.val(hidden_cvc_field.val());

    var exp_components = hidden_exp_field.val().split("/")
    stripe_exp_month_field.val(exp_components[0]);
    stripe_exp_year_field.val(exp_components[1]);
  }

  jQuery(function($) {
    $('#payment_form').submit(function(event) {
      var $form = $(this);
      $form.find('button').prop('disabled', true);

      // Synchronous call (Stripe explicit)
      if (hidden_card_number_field.val() == '') {
        Stripe.card.createToken($form, function(status, response) {
          if (response.error) {
            $('.payment_errors').remove();
            $('<div class="payment_errors"><ul><li class="error_text" style="color:red"></li></ul></div>').insertAfter('#errors');

            $('.error_text').text(response.error.message);

            $form.find('button').prop('disabled', false);
          } else {
            var stripe_token = response.id;

            var card_number = $form.find('#card_number').val();
            var cvc = $form.find('#cvc').val();
            var exp_month = $form.find('#exp_month').val();
            var exp_year = $form.find('#exp_year').val();

            var masked_cc_first_four = card_number.substring(0, 4),
                masked_cc_last_four = card_number.substring(card_number.length - 4);
            var masked_cc = masked_cc_first_four.concat("********", masked_cc_last_four);

            stripe_token_field.val(stripe_token);
            hidden_card_number_field.val(masked_cc);
            hidden_cvc_field.val('***');
            hidden_exp_field.val(exp_month.concat('/', exp_year));

            package_form.submit()
          }
        });
      } else {
        package_form.submit()
      }

      return false;
    });
  });
});
