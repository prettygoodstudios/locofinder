mapboxgl.accessToken = 'pk.eyJ1IjoicHJldHR5Z29vZHN0dWRpb3MiLCJhIjoiY2pkamx4aTZlMWt4dDJwbnF5a3ZmbTEzcyJ9.lu_9eqO1kmUMPf9LXU80yg';
var map = new mapboxgl.Map({
  container: 'map',
  style: 'mapbox://styles/prettygoodstudios/cjdjnyk9047qy2rmm28tmk0m8'
});
var nav = new mapboxgl.NavigationControl();
map.addControl(nav, 'top-left');

$(document).on('turbolinks:load', function(){
  console.log("Hello World!");
  fetch(ROOT_URL+"geo_json_api").then(function(r){
    return r.json();
  }).then(function(d){
    for( var i = 0; i < d.length; i++ ){
      var el = document.createElement('div');
      el.className = 'marker';
      var marker = new mapboxgl.Marker(el,{ offset: [0, -35] }).setLngLat([d[i].coordinates[1],d[i].coordinates[0]]).addTo(map);
      var title = "<h3>"+d[i].title+"</h3>";
      var address = "<p>"+d[i].address+"</p>";
      var average_score = "<p>Average Rating: "+d[i].average_score+"</p>"
      if(d[i].average_score == 0){
        average_score = "";
      }
      var image = "<image class='popup-image' src='"+d[i].img_url+"'></image>";
      if(d[i].offsetX && d[i].offsetY){
        var scaleRatio = (200/400)*d[i].zoom;
        var marginLeft = d[i].offsetX*scaleRatio;
        var marginTop = d[i].offsetY*scaleRatio;
        var width = d[i].width*scaleRatio;
        var height = d[i].height*scaleRatio;
        image = "<image class='popup-image' src='"+d[i].img_url+"' style='margin-left:"+marginLeft+"px; margin-top:"+marginTop+"px; width: "+width+"px; height: "+height+"px;'></image>";
      }
      var imageWrapper = d[i].img_url ?  "<div style='width: "+(d[i].offsetX ? 200 : 300)+"px; height: 200px; overflow: hidden; margin: auto auto 20px auto;'>"+image+"</div>" : "";
      var link = "<a href='"+ROOT_URL+d[i].url+"' class='button' data-turbolinks='false'>More Info</a>";
      var popup = new mapboxgl.Popup().setHTML(title+address+average_score+imageWrapper.toString()+link);
      marker.setPopup(popup);
    }
    fetch("https://geoip-db.com/json/").then(function(r){
      return r.json();
    }).then(function(data){
      console.log("Hello World 2");
      console.log(data);
      map.flyTo({center: [data.longitude, data.latitude], zoom: 9});
    }).catch(function(e){
      console.log("Error Fetching Coordinates", e);
    });
  });
});
