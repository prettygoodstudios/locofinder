function getIpLocation(a){map.flyTo({center:[a.location.longitude,a.location.latitude],zoom:9})}mapboxgl.accessToken="pk.eyJ1IjoicHJldHR5Z29vZHN0dWRpb3MiLCJhIjoiY2pkamx4aTZlMWt4dDJwbnF5a3ZmbTEzcyJ9.lu_9eqO1kmUMPf9LXU80yg";var map=new mapboxgl.Map({container:"map",style:"mapbox://styles/prettygoodstudios/cjdjnyk9047qy2rmm28tmk0m8"}),nav=new mapboxgl.NavigationControl;map.addControl(nav,"top-left"),$.get(ROOT_URL+"geo_json_api").then(function(a){for(var o=0;o<a.length;o++){var e=document.createElement("div");e.className="marker";var t=new mapboxgl.Marker(e,{offset:[0,-35]}).setLngLat([a[o].coordinates[1],a[o].coordinates[0]]).addTo(map),n="<h3>"+a[o].title+"</h3>",r="<p>"+a[o].address+"</p>",p="<p>Average Rating: "+a[o].average_score+"</p>";0==a[o].average_score&&(p="");var i="<image class='popup-image' src='"+a[o].img_url+"'></image>",l="<a href='"+ROOT_URL+a[o].url+"' class='button' data-turbolinks='false'>More Info</a>",s=(new mapboxgl.Popup).setHTML(n+r+p+i+l);t.setPopup(s)}}),geoip2.insights(getIpLocation,function(a){console.log("Get Location Error",a)});