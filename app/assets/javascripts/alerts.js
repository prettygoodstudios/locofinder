$(".close").click(function(){
  $(".modal").hide();
});
$(document).ready(function(){
  lastWidth = window.innerWidth;
  $(".modal").show();
  $("#toggle").click(function(){
    $(".hamburger").toggleClass("is-active");
    $(".nav ul").toggle();
  });
});
$(window).click(function(){
  $(".modal").hide();
});
var lastWidth = 1000;
$(window).resize(function(){
  if (window.innerWidth < 500 && lastWidth > 500){
    $(".nav ul").hide();
    $(".hamburger").removeClass("is-active");
  }else if (window.innerWidth > 500){
    $(".nav ul").css("display","inline");
    $(".hamburger").removeClass("is-active");
  }
  lastWidth = window.innerWidth;
});
