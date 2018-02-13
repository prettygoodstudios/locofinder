mapboxgl.accessToken = 'pk.eyJ1IjoicHJldHR5Z29vZHN0dWRpb3MiLCJhIjoiY2pkamx4aTZlMWt4dDJwbnF5a3ZmbTEzcyJ9.lu_9eqO1kmUMPf9LXU80yg';
var map = new mapboxgl.Map({
  container: 'map',
  style: 'mapbox://styles/prettygoodstudios/cjdjnyk9047qy2rmm28tmk0m8'
});
var nav = new mapboxgl.NavigationControl();
map.addControl(nav, 'top-left');
$.get(ROOT_URL+"geo_json_api").then(function(d) {
  for( var i = 0; i < d.length; i++ ){
    var el = document.createElement('div');
    el.className = 'marker';
    var marker = new mapboxgl.Marker(el).setLngLat([d[i].coordinates[1],d[i].coordinates[0]]).addTo(map);
    var title = "<h1>"+d[i].title+"</h1>";
    var address = "<p>"+d[i].address+"</p>";
    var average_score = "<p>Average Score: "+d[i].average_score+"</p>"
    var image = "<image class='popup-image' src='"+d[i].img_url+"'></image>"
    var link = "<a href='"+ROOT_URL+d[i].url+"' class='button'>More Info</a>";
    var popup = new mapboxgl.Popup().setHTML(title+address+average_score+image+link);
    marker.setPopup(popup);
  }
});
$.get(ROOT_URL+"my_location_api").then(function(d){
  map.flyTo({center: [d.longitude, d.latitude], zoom: 9});
});
