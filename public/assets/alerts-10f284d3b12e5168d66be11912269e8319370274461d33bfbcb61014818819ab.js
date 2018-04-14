$( document ).on('turbolinks:load', function() {
  var show = true;
  var lastWidth = window.innerWidth;
  $("#toggle").click(function(){
    if(show){
      show = false;
      $(".nav ul").show();
      $("#toggle").addClass("is-active");
    }else{
      show = true;
      $(".nav ul").hide();
      $("#toggle").removeClass("is-active");
    }
  });
  if($(".modal-body").html != ""){
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
      $(".nav ul").hide();
      $(".hamburger").removeClass("is-active");
      show = true;
    }else if (window.innerWidth > 500){
      $(".nav ul").css("display","inline");
      $(".hamburger").removeClass("is-active");
    }
    lastWidth = window.innerWidth;
  });
});
