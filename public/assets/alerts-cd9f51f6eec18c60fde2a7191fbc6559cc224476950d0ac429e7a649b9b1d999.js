$(document).on("turbolinks:load",function(){var i=!0,n=window.innerWidth;$("#toggle").click(function(){i?(i=!1,$(".nav ul").show(),$("#toggle").addClass("is-active")):(i=!0,$(".nav ul").hide(),$("#toggle").removeClass("is-active"))});var e=$.trim($(".modal-body").text()).length;console.log(e),0!=e&&(console.log("Showwing"),$(".modal").show()),$(window).click(function(){$(".modal").hide()}),$(".close").click(function(){$(".modal").hide()}),$(window).resize(function(){window.innerWidth<500&&n>500?($(".nav ul").hide(),$(".hamburger").removeClass("is-active"),$(".user-tab ul").css("display","block"),i=!0):window.innerWidth>500&&($(".nav ul").css("display","inline"),$(".hamburger").removeClass("is-active"),$(".user-tab ul").css("display","none")),n=window.innerWidth}),$(".user-tab").hover(function(){window.innerWidth>500&&$(".user-tab ul").css("display","block")}),$(".user-tab").mouseleave(function(){window.innerWidth>500&&$(".user-tab ul").css("display","none")})});