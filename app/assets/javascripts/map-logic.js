var map;
var data;
function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    zoom: 10,
    center: {lat: -28, lng: 137}
  });
  // NOTE: This uses cross-domain XHR, and may not work on older browsers.
  var markers = [];
  var infoWindows = [];
  $.get(ROOT_URL+"geo_json_api", function( d ) {
    data = d;
    console.log(data);
    map.setCenter({lat: data[0].coordinates[0] ,lng: data[0].coordinates[1]});
    for( var i =0;  i < data.length; i++){
      var marker = new google.maps.Marker({
            position: {lat: data[i].coordinates[0] ,lng: data[i].coordinates[1]},
            map: map,
            title: 'Hello World!'
      });
      var image = "";
      if(data[i].img_url != ""){
        image = "<img src='"+data[i].img_url+"'/>"
      }
      var content = "<div class='window'><h1>"+data[i].title+"</h1><h5>Average Score: "+data[i].average_score+"</h5>"+image+"<a href='"+data[i].url+"' class='button'>More Details!</a><a href='"+data[i].edit+"' class='button'>Edit</a><a href='"+data[i].url+"' data-method='delete' class='button'>Delete</a></div>";
      var infoWindow = new google.maps.InfoWindow({
        content: "<h1>"+data[i].title+"</h1><a href='"+data[i].url+"'>More Details!</a><a href='"+data[i].edit+"'>Edit</a><a href='"+data[i].url+"' method='delete'>Delete</a>"
      });
      google.maps.event.addListener(marker,'click', (function(marker,content,infoWindow){
          return function() {
              infoWindow.setContent(content);
              infoWindow.open(map,marker);
          };
      })(marker,content,infoWindow));
    }
  });
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };

      map.setCenter(pos);
    }, function() {

    });
  } else {
    // Browser doesn't support Geolocation
  }

}
