$( document ).ready( function() {
  Stripe.setPublishableKey('pk_test_lgoJadzJlZSpLwrY1sJPinZK'); // This is a test key. Don't deploy it to production.

  jQuery(function($) {
    $('#payment-form').submit(function(event) {
      var $form = $(this);
      $form.find('button').prop('disabled', true);

      var package_type = $('#package-form').find('#package-select').val();
      var number_of_tickets = $('#package-form').find('#quantity-select').val();
      var total = $('#package-form').find('#total-value').text();
      var customer_name = $('#personal-info-form').find('#customer-name').val();

      // Synchronous call (Stripe explicit)
      Stripe.card.createToken($form, function(status, response) {
        if (response.error) {
          alert('error');
        } else {
          var stripe_token = response.id;
          var url = document.URL + 'purchase';

          $.post(url, {token: stripe_token, package_type: package_type, ticket_quantity: number_of_tickets, charge_amount: total, customer_name: customer_name})
            .done(function (data) {
              window.location.href = document.URL + 'success';
            });
        }
      });

      return false;
    });
  });

  $('#package-form').change(function () {
    var quantity = $( '#quantity-select' ).val();
    var package_select = $( '#package-select' ).val();

    if (package_select == 'Adult Caverns Tour ($21.99)') {
      var rate = 21.99;
    } else if (package_select == 'Child Caverns Tour ($17.99)') {
      var rate = 17.99;
    } else {
      var rate = 4.99;
    }

    var precise_subtotal = rate * quantity;
    var rounded_subtotal = money_round(precise_subtotal);
    $( "#subtotal-value" ).text(rounded_subtotal);

    var precise_tax = rounded_subtotal * 0.04;
    var rounded_tax = money_round(precise_tax);
    $( "#tax-value" ).text(rounded_tax);

    var precise_total = rounded_subtotal + rounded_tax;
    var rounded_total = money_round(precise_total);
    $( "#total-value" ).text(rounded_total);
  });

  function money_round(num) {
    return Math.ceil(num * 100) / 100;
  }
});
