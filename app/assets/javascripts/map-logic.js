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
    map.setCenter({lat: data.features[0].geometry.coordinates[0] ,lng: data.features[0].geometry.coordinates[1]});
    for( var i =0;  i < data.features.length; i++){
      var marker = new google.maps.Marker({
            position: {lat: data.features[i].geometry.coordinates[0] ,lng: data.features[i].geometry.coordinates[1]},
            map: map,
            title: 'Hello World!'
      });
      var infoWindow = new google.maps.InfoWindow({
        content: "Hello World"
      });
      google.maps.event.addListener(marker,'click', (function(marker,content,infoWindow){
          return function() {
              infoWindow.setContent("Hello World!");
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
