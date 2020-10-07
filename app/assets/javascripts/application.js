// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery3
//= require jquery_ujs
//= require popper

//= require bootstrap-sprockets
//= require toastr/build/toastr.min
//= require_tree .

toastr.options = {
  "closeButton": true,
  "debug": false,
  "newestOnTop": false,
  "progressBar": true,
  "positionClass": "toast-top-right",
  "preventDuplicates": false,
  "onclick": null,
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "3000",
  "extendedTimeOut": "4000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "slideDown",
  "hideMethod": "slideUp",
  "borderRadius": '8px'
};

$(document).on('show.bs.modal', function (e) {
  $("a[data-remote]").on("ajax:success", function(e, data, status, xhr) {
    $('.modal-content').html(data)
  });
})

$(document).on('hidden.bs.modal', function() {
});
