$(".close").click(function(){
  $(".modal").hide();
});
$(document).ready(function(){
  lastWidth = window.innerWidth;
  var show = true;
  $("#toggle").click(function(){
    $(".hamburger").toggleClass("is-active");
    if(show){
      show = false;
      $(".nav ul").show();
    }else{
      show = true;
      $(".nav ul").hide();
    }
  });
  $(".modal").show();
});
$(window).click(function(){
  $(".modal").hide();
});
var lastWidth = 0;
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
