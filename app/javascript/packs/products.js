import $ from 'jquery'

$(document).on('turbolinks:load', function () {

  $(".nested_fields_btn").data("association-insertion-method", 'after');

  $(".clickable-row").click(function () {
    window.location = $(this).data("href");
  });

  $('tr.header').click(function() {
    $('.expanded').slideUp(200);
    if (!$(this).hasClass('expanded-header')) {
      $(this).nextUntil('tr.header').addClass('expanded').toggle("slow");
      $('.expanded-header').removeClass('expanded-header');
      $(this).addClass('expanded-header');
    } else {
      $(this).removeClass('expanded-header');
    }
  });

})
