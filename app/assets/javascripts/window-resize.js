$(document).ready(function () {
  if($(window).height() > 800) {
    $(".full-section").height($(window).height());
    $(window).resize(function () {
      $(".full-section").height($(window).height())
    });
  }
});