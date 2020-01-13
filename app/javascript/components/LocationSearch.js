import React from "react";
import PropTypes from "prop-types";
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
