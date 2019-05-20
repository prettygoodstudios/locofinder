let lastTouchPosX = 10000;

$( document ).on('turbolinks:load', function() {
  var show = true;
  var lastWidth = window.innerWidth;
  $("#toggle").click(function(){
    if(show){
      show = false;
      $(".nav ul").addClass("is-open");
      $("#toggle").addClass("is-active");
    }else{
      show = true;
      $("#toggle").removeClass("is-active");
      $(".nav ul").removeClass("is-open");
    }
  });

  document.addEventListener("touchstart", (e) => {
    lastTouchPosX = e.touches[0].clientX;
  });

  document.addEventListener("touchmove", (e) => {
    const touchX = e.touches[0].clientX;
    console.log(touchX - lastTouchPosX, lastTouchPosX);
    if(lastTouchPosX < 50 && touchX - lastTouchPosX > 50 && show && window.innerWidth < 500){
      show = false;
      $(".nav ul").addClass("is-open");
      $("#toggle").addClass("is-active");
      lastTouchPosX = 10000;
    }else if(lastTouchPosX < 200 && touchX - lastTouchPosX < -50 && !show && window.innerWidth < 500){
      show = true;
      $(".nav ul").removeClass("is-open");
      $("#toggle").removeClass("is-active");
      lastTouchPosX = 10000;
    }
  });

  var content = $.trim( $('.modal-body').text() ).length;
  console.log(content);
  if(content != 0){
    console.log("Showwing");
    $(".modal").show();
  }
  $(window).click(function(){
    $(".modal").hide();
  });
  $(".close").click(function(){
    $(".modal").hide();
  });
  $(window).resize(function(){
    if (window.innerWidth < 500 && lastWidth > 500){
      $(".nav ul").removeClass("is-open");
      $(".hamburger").removeClass("is-active");
      $(".user-tab>ul").css("display", "block");
      show = true;
    }else if (window.innerWidth > 500){
      $(".nav ul").css("display","inline");
      $(".nav ul").removeClass("is-open");
      $(".hamburger").removeClass("is-active");
      $(".user-tab ul").css("display", "none");
    }
    lastWidth = window.innerWidth;
  });
  $(".user-tab").hover( function() {
    if (window.innerWidth > 500){
      $(".user-tab ul").css("display", "block");
    }
  });
  $(".user-tab").mouseleave(function() {
    if (window.innerWidth > 500){
      $(".user-tab ul").css("display", "none");
    }
  });
});
