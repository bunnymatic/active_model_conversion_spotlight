$(function() {
  $('.tooltip').tinytooltip({
    message: function() { return $(this).attr('title') || $(this).data('tooltip') }
  });
});