import React from "react";
import PropTypes from "prop-types";

mapboxgl.accessToken = 'pk.eyJ1IjoicHJldHR5Z29vZHN0dWRpb3MiLCJhIjoiY2pkamx4aTZlMWt4dDJwbnF5a3ZmbTEzcyJ9.lu_9eqO1kmUMPf9LXU80yg';
var map = new mapboxgl.Map({
  container: 'map',
  style: 'mapbox://styles/prettygoodstudios/cjdjnyk9047qy2rmm28tmk0m8'
});
var nav = new mapboxgl.NavigationControl();
map.addControl(nav, 'top-left');

const loadMap = (d) => {
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
}

class LocationSearch extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      locations: [],
      filteredLocations: [],
      searchQuery: "",
      selectedLocation: -1
    }
  }
  componentDidMount(){
    $.get(this.props.rootUrl+"geo_json_api").then(data =>{
      var locos = [];
      for(var i = 0; i < data.length; i++){
        locos.push(data[i]);
      }
      loadMap(data);
      this.setState({
        locations: locos
      });
    });
    const searchBar = document.querySelector(".location-search");
    searchBar.addEventListener("keydown", (e) => {
      const {selectedLocation, filteredLocations} = this.state;
      switch(e.key){
        case "ArrowUp":
          if(selectedLocation > -1){
            this.setState({
              selectedLocation: selectedLocation-1
            });
          }
          break;
        case "ArrowDown":
          if(selectedLocation < filteredLocations.length-1){
            this.setState({
              selectedLocation: selectedLocation+1
            });
          }
          break;
        case "Enter":
          if(selectedLocation != -1) window.location = this.props.rootUrl+"location/"+filteredLocations[selectedLocation].slug;
          break;
        default:
          break;
      }
    });
  }
  handleSearchFormChange = (event) =>{
    const {searchQuery, locations, selectedLocation, filteredLocations} = this.state;
    const target = event.target;
    const value = target.value;
    let filtered = locations.filter(
      (location) => {
        const searchTerms = value.split(" ");
        let found = false;
        searchTerms.forEach((t) => {
          if(this.subQuery(t, location)){
            found = true;
          }
        });
        return found;
      }
    );
    filtered = this.sortByPoints(filtered, searchQuery);
    if (filtered.length > 7) filtered.length = 7;
    this.setState({
      searchQuery: value,
      filteredLocations: filtered,
      selectedLocation: this.areResultsEquivalent(filtered, filteredLocations) ? selectedLocation : -1
    });
  };

  areResultsEquivalent = (res1, res2) => {
    if(res1.length != res2.length){
      return false;
    }
    res1.forEach((r1, i) => {
      if(r1.url != res2[i].url){
        return false;
      }
    });
    return true;
  }

  sortByPoints = (arr, sQ) =>{
    let retVal = arr.sort(function(a,b){
      let pointsB = 0;
      let pointsA = 0;
      let termMatchesA = 0;
      let termMatchesB = 0;
      sQ.split(" ").forEach((searchQ) => {
        const searchQuery = searchQ.trim();
        if(searchQuery != ""){
          let titleA = a.title.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
          let addressA = a.address.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
          if(titleA){
            pointsA += 2;
          }
          if(addressA){
            pointsA++;
          }
          a.title.toLowerCase().split(" ").forEach((t) => {
            const tA = t.trim();
            if(tA == searchQuery){
              termMatchesA++;
            }
          });
          a.address.toLowerCase().split(" ").forEach((a) => {
            const aA = a.trim();
            if(aA == searchQuery){
              termMatchesA++;
            }
          });

          let titleB = b.title.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
          let addressB = b.address.toLowerCase().indexOf(searchQuery.toLowerCase()) !== -1;
          b.title.toLowerCase().split(" ").forEach((t) => {
            const tB = t.trim();
            if(tB == searchQuery){
              termMatchesB++;
            }
          });
          b.address.toLowerCase().split(" ").forEach((a) => {
            const aB = a.trim();
            if(aB == searchQuery){
              termMatchesB++;
            }
          });
          if(titleB){
            pointsB += 2;
          }
          if(addressB){
            pointsB++;
          }
        }
      });
      pointsA += termMatchesA;
      pointsB += termMatchesB;
      if (pointsA > pointsB) {
        return -1;
      }
      if (pointsA < pointsB) {
        return 1;
      }
    });
    return retVal;
  }

  subQuery = (sQ, location) => {
    return sQ.trim() == "" ? false : location.address.toLowerCase().indexOf(sQ.toLowerCase().trim()) !== -1 || location.title.toLowerCase().indexOf(sQ.toLowerCase().trim()) !== -1;
  }

  render () {
    const {filteredLocations, searchQuery, selectedLocation} = this.state;
    let results = filteredLocations.map((location, i) => {
      const selectedClass = i == selectedLocation ? " selected-search-result" : "";
      return(
        <a href={this.props.rootUrl+"location/"+location.slug} className={"location-search-result"+selectedClass} data-turbolinks="false">
          <h3>{location.title}</h3>
          <p>{location.address}</p>
        </a>
      );
    });
    return (
      <div className="location-search">
        <input type="text" value={searchQuery} onChange={this.handleSearchFormChange} placeholder="&#xF002; Search" style={{fontFamily: "Avenir Heavy ,FontAwesome"}}/>
        { searchQuery != "" && results }
      </div>
    );
  }
}
LocationSearch.propTypes = {
  rootUrl: PropTypes.string
};
export default LocationSearch;
